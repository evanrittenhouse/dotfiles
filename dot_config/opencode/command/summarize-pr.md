---
description: Summarize a PR's entrypoints, change flow, tests, CI, reviewer risks, and quiz the user on the implementation
argument-hint: <PR URL | number | branch>
---

# Summarize PR

## Overview

Create a reviewer-ready summary of a pull request. Focus on its entrypoints, what changed, why the changed files matter, what was tested, and where reviewers should spend attention.

This is not a full adversarial code review. Do enough inspection to identify important sections and plausible risks, but do not approve, request changes, post comments, or modify code unless the user explicitly asks.

## Resolve the PR

Accept a GitHub PR URL, PR number, or branch name. If the target is a number and the current repository is ambiguous, ask for the repository or infer it from the current checkout.

Use `gh` for PR data. GitHub commands need network access, so request sandbox escalation when the harness requires it.

If the PR is too large to read in one pass, use the file list and file stats to prioritize patches. Read generated files, vendored files, lockfiles, and snapshots only after understanding the source changes that produced them.

## Inspect the Change

Build the summary from primary PR artifacts, not only the PR description.

1. Read the PR title, body, labels, commit subjects, changed-file list, and file stats.
2. Classify changed files by role: public API, core logic, lifecycle or concurrency, persistence or migrations, auth or security, infra or deployment, tests, generated artifacts, documentation.
3. Read the most important patches. Prioritize files with user-visible behavior, shared libraries, lifecycle management, goroutines or async work, locking, retries, cancellation, migrations, permissions, configuration, and deletion paths.
4. Identify the change's entrypoint or entrypoints: the commands, handlers, public APIs, controllers, hooks, jobs, or startup paths through which the new behavior is invoked. Include file, line, symbol, caller, and role. If the change is not wired into production code, say so explicitly.
5. Trace the main control, data, dependency, or lifecycle flow through the changed behavior. Use only relationships supported by the code or PR artifacts.
6. Identify tests added or changed. Capture what they cover and what risk they leave uncovered.
7. Read CI status from `statusCheckRollup`; distinguish passing, failing, pending, skipped, and missing checks.
8. If a file requires more context, inspect nearby source in the local checkout or via `gh api` before summarizing it.

Use local checkout commands only for reading:

```bash
git status --short
rg -n "symbol_or_identifier" path/to/file
nl -ba path/to/file | sed -n '120,180p'
```

## Point to Critical Sections

Critical sections are locations a reviewer should inspect, not every changed hunk. Prefer 3-8 sections unless the PR is large.

For each section, include:

- File and line number or small line range.
- What changed there.
- Why it is review-critical.
- The specific question a reviewer should answer.

If a checked-out copy is available, line numbers from the head version are enough. If GitHub links are useful, generate exact links instead of hand-building them:

```bash
gh browse "path/to/file:LINE" -R OWNER/REPO --commit HEAD_SHA --no-browser
```

Use `headRepository.nameWithOwner` and `headRefOid` from `/tmp/summarize-pr/pr.json` for `OWNER/REPO` and `HEAD_SHA`, especially for cross-repository PRs.

## Diagram the Change

When the PR has a meaningful runtime, data, dependency, or lifecycle flow, include a small ASCII diagram of it. Use actual component or symbol names, and show the main entrypoint, changed logic, important branches, and outcome where applicable. Keep it basic enough to read in a terminal.

Do not invent relationships to complete a diagram. Omit the diagram for changes such as documentation, formatting, or dependency updates when it would not improve understanding.

## Risk Lens

Flag important areas to review even when you are not certain they are bugs. Label them as review focus, risk, or test gap rather than findings unless the evidence is conclusive. The following IS NOT an exhaustive list, but a guide on the types of things to look for.

Check for issues like:

- **Race conditions**: shared mutable state, goroutines, async callbacks, event handlers, parallel tests, locks, atomics, channel closing, request cancellation.
- **Lifecycle issues**: startup and shutdown order, cleanup, ownership transfer, finalizers, subscriptions, watchers, retries, background workers, timers, context propagation.
- **Data compatibility**: migrations, schema changes, serialization formats, defaults, nil or zero-value behavior, backfills, downgrade paths.
- **Rollout and config**: feature flags, environment variables, Helm or Terraform changes, default behavior, partial deployment safety.
- **Security and privacy**: authorization checks, token handling, secret logging, tenant boundaries, path traversal, injection risk.
- **Error handling**: retry loops, idempotency, timeouts, cancellation, partial failure, observability around failures.
- **Performance**: new loops over unbounded collections, extra network calls, N+1 behavior, cache invalidation, memory ownership, blocking syscalls.
- **Tests**: missing negative tests, concurrency tests, lifecycle cleanup tests, migration tests, integration coverage, flaky timing assumptions.
- **Boundaries**: API contracts, package boundaries, proper encapsulation.

## Quiz the User

After the summary, ask 3-5 numbered, open-ended questions that test whether the user understands the PR's implementation. Then stop and wait for the user's answers.

Choose questions about the central behavior, such as:

- How execution or data moves from the entrypoint to the result.
- Why the main implementation choice is needed.
- Which invariant, edge case, or failure path the code must preserve.
- How the tests prove the behavior and what important gap remains.
- How configuration, rollout, compatibility, or lifecycle behavior changes.

Together, the questions must cover the main implementation and at least one important risk or invariant. Ask only questions that the inspected code or PR artifacts can answer. Do not use gotchas, trivia, yes/no questions, vague opinions, or details unrelated to the change. Do not include hints or answers in the questions.

After the user answers, grade each response as **Correct**, **Partial**, or **Incorrect**. Give a brief correction or missing detail with file and line references. Be direct, and do not ask another quiz round unless the user requests one.

## Output Shape

Use this structure unless the user asks for a different format:

```markdown
**PR Summary**
<title, PR number, author, base -> head, draft/state, size>

**Net Change**
- <2-5 bullets describing behavior and intent>

**Change Flow**
<small ASCII diagram using actual component or symbol names; omit when no useful flow exists>

**Entrypoints**
| Entrypoint | Invoked By | Role |
| --- | --- | --- |
| path/to/file:123 `Symbol` | <caller, command, framework, or not yet wired> | <how execution enters the changed behavior> |

**Important Files**
| File | Why It Matters | Change |
| --- | --- | --- |
| path/to/file | <role in system> | <important change> |

**Critical Sections**
| Section | Review Focus | Why |
| --- | --- | --- |
| path/to/file:123 | <question or concern> | <risk or invariant> |

**Tests and CI**
- Tests changed: <files and what they cover>
- CI: <pass/fail/pending/skipped summary>
- Gaps: <missing tests or validation worth adding>

**Reviewer Focus**
- <race/lifecycle/rollout/security/perf/test-review prompts, as applicable>

**Not Verified**
- <anything not checked, inaccessible, too large, or outside scope>

**Understanding Quiz**
1. <meaningful implementation question>
2. <meaningful implementation question>
3. <meaningful implementation question>
4. <optional meaningful implementation question>
5. <optional meaningful implementation question>
```

Keep summaries factual and reviewer-oriented. Avoid restating every file in the diff. Do not invent test execution; say whether evidence came from changed test files, PR text, CI checks, or commands you personally ran. End the initial response after the quiz questions so the user can answer them.
