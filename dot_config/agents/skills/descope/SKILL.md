---
name: descope
description: >-
  Cut a changeset down to what the prompt asked for. Reverts drive-by refactors, renames,
  reformatting, and other edits unrelated to the request without asking. For coherent
  unrequested features such as metrics, logging, retries, caching, config flags, extra tests,
  docs, or a wider reading of the request than its words, asks the user whether to keep or
  remove each one, then removes what they decline. Use after an LLM-assisted implementation
  and before review or commit, whenever the user says the diff is bloated, "I didn't ask for
  that", "trim this to the request", or wants out-of-scope code removed. Not a bug or
  code-quality review.
---

# Descope

LLM-assisted changes accrete code nobody asked for: a refactor of the function next door, a
rename, a metrics counter, a retry loop, a rewritten docstring. Each addition costs review
time, widens the blast radius, and buries the requested change. The goal is a diff in which
every hunk traces back to the request.

Two kinds of excess need different handling. Noise (reformatting, renames, unrelated
refactors) is never a reading of the request, so remove it without asking. An unrequested
feature (metrics, retries, extra validation) may be the agent's honest interpretation of
what the user wanted, and only the user knows. Ask about those, and only those, so every
question is worth the user's time.

## Recover the request

Scope is defined by the request, so pin it down before reading the diff.

- Use the prompt the user gives when invoking the skill.
- Otherwise, use the original request from the conversation.
- Otherwise, use the commit messages, PR title and description, or a ticket linked from the
  branch name.
- If none exist, ask the user for the request before classifying anything.

Do not infer the scope from the diff. The diff is what is under suspicion.

Restate the request as one or two sentences of requested behavior, plus any exclusions the
user stated. Include this in the report so a misread request is visible.

## Establish the changeset

Use the diff, branch, or commit range the user names. Otherwise review the working tree,
the index, and commits since the merge base with the default branch. Record the base
revision; removed lines are restored from it with `git show <base>:<path>`.

## Classify every hunk

Assign each hunk to exactly one bucket. Where a hunk mixes buckets, split it at the line
level.

1. **Requested.** Directly implements the request. Keep.
2. **Required.** Not named in the request, but the requested code cannot compile, run, or be
   tested without it: a new import, a type or parameter the feature threads through, a call
   site updated for a changed signature, a test that exercises the requested behavior. Keep.
   The test for required is concrete: name the requested line that breaks without it. If
   you cannot, it is not required.
3. **Unrelated.** Touches code the request has nothing to do with: refactors of neighboring
   functions, renames for clarity, reformatting, import reordering, comment or docstring
   edits on untouched logic, whitespace, dependency bumps, type annotations added to
   existing code, `TODO` cleanup. Remove without asking.
4. **Unrequested feature.** A coherent addition an agent could plausibly believe the request
   implied, but which the request does not say: metrics or telemetry, logging, retries and
   backoff, caching, feature flags, config options, CLI flags, input validation beyond what
   the feature needs, error handling for cases the request did not mention,
   backwards-compatibility shims, tests for behavior not requested, README or doc changes,
   generalizations beyond the stated case. This also covers a reading of the request wider
   than its words, such as applying the change to more call sites, modules, or platforms
   than the request names. Group by feature and ask before removing.

When you cannot decide between requested and unrequested feature, ask. When you cannot
decide between required and unrelated, keep it and flag it in the report. Errors in these
directions cost one question or one flagged line; the opposite errors delete working code
silently.

## Ask about unrequested features

Ask about every bucket-4 feature in one round before removing any of them. For each
feature:

- Name it in the user's terms: "Prometheus counter for cache hits", not "lines 40 to 58 of
  cache.rs".
- List where it lives, including its plumbing: imports, manifest entries, config keys,
  helper functions, tests, docs.
- Offer keep or remove.

Use a structured question tool when one exists; otherwise ask in prose as a numbered list.
Apply the answer at the granularity the user gives. "Keep the counter, drop the histogram"
splits the feature.

Do not ask about bucket-3 hunks, and do not ask for confirmation on buckets 1 and 2. The
report covers those.

## Remove

- Bucket 3: restore the lines from the base revision. Delete new files that are wholly
  unrelated. Restore deleted files.
- Bucket 4 with a "remove" answer: remove the whole feature group together with plumbing
  that only it used. Leftover plumbing is dead code the request did not ask for either,
  and it invites the feature to be rebuilt.
- After each removal, re-check bucket 2. An import or helper that was required only by a
  removed feature is now unrelated.
- Fix breakage from a removal only by restoring or removing lines. Adding new code is
  outside the scope of a descope.

Work in the working tree. Leave the result uncommitted unless the user asks otherwise, and
do not rewrite history. If the changeset was already committed, say so in the report and
let the user choose between amend, squash, and a new commit.

## Verify

Run what the repository runs: build, tests, lint. If something fails, find the removed lines
it depended on. Those lines were required, not unrelated: restore them, reclassify, and note
the correction in the report. If there is no runnable check, say so.

## Report

Keep it short; the diff is the deliverable.

- The request as understood, in one or two sentences.
- Removed as unrelated: `file:line` ranges with a few words each.
- Asked: each feature, the answer, and what was removed or kept.
- Kept as required though unnamed in the request: what, and which requested line needs it.
- Flagged: hunks kept because their bucket was unclear.
- Verification: the command and its result.
- Follow-ups: refactors or features removed that may be worth a separate change.

## Traps

- **Words versus intent.** "Add a retry" needs error handling around the retried call.
  Required means required by the request's intent, not by its literal words.
- **Tests as a block.** Classify each test on its own. A test of requested behavior is
  required. A test of an unrequested feature leaves with the feature. A test the agent
  added for pre-existing behavior is unrelated.
- **Formatter runs.** If a whole file was reformatted, restore it from base and reapply only
  the requested lines. Hand-unformatting a large hunk is slower and error-prone.
- **Renames.** A rename forced by the requested code, such as a new parameter colliding with
  a local, is required. A rename for clarity is unrelated. Check whether requested lines
  reference the new name.
- **"It is better this way."** The refactor may be good. It is a different change with a
  different review. List it under follow-ups and remove it.
