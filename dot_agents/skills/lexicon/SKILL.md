---
name: lexicon
description: >-
  Extract the bespoke or unconventional terms an LLM-assisted change coins for abstract
  objects, processes, and concepts. Writes an untracked GLOSSARY.md at the repository root
  with each term's meaning, rationale, and alternative names, pauses for the user to confirm
  each term or supply their own, then renames across the changeset to match. Use after an
  LLM-assisted implementation when the user says they do not understand the names, asks what
  a term means, wants the vocabulary mapped to their own, or says "lexicon", "glossary",
  "extract the terms", or "rename the bespoke terms". Not a bug, scope, or style review.
---

# Lexicon

LLM-assisted changes coin names. Each name encodes a concept model the author held, and
the reader has to reverse-engineer it. Conventional names (`Iterator`, `handler`, `ctx`)
cost nothing. Bespoke names, such as metaphors, overloaded words, or jargon from a domain
the reader does not share, cost a translation on every read. The goal is a mapping from the
change's vocabulary to the user's, applied to the code, so the change reads in the user's
language.

The user confirms two things per term: the word, and the meaning. A corrected word is a
rename. A corrected meaning is a signal that the concept itself may be muddled, and needs
a second look before any rename.

## Resume or start

If `GLOSSARY.md` from a previous run exists at the repository root, read it and go to
[Apply decisions](#apply-decisions). Otherwise start here.

## Establish the changeset

Use the diff, branch, or commit range the user names. Otherwise review the working tree,
the index, and commits since the merge base with the default branch. Record the base
revision; it separates names the change introduced from names the codebase already had
(`git grep -w <term> <base>`).

## Extract terms

Scan everything the change adds or edits:

- Identifiers: types, traits and interfaces, enum variants, functions, methods, modules,
  fields, parameters, config keys, CLI flags, environment variables, error kinds, states and
  phases, events, metric and log names, test names.
- Prose: words in comments, docstrings, commit messages, and PR text that name a concept.

A term qualifies when all three hold:

1. **The change introduced it.** Check the base revision. A name that existed before is the
   codebase's vocabulary, not the change's. The exception is an existing name the change
   uses in a new sense; list that as an overload.
2. **It names an abstract thing.** An object, role, process, state, boundary, or
   relationship. Loop indices, trivial locals, and names that restate their type
   (`user: User`) do not qualify.
3. **It is not conventional** for the language, framework, or codebase. Skip `Builder`,
   `Handler`, `ctx`, `cfg`, and `Repository` in a project that already has repositories. The
   test: would a reader who knows the language and the codebase, but not this change, need
   the word explained?

Also list these, since they cost the reader more than a single odd word:

- **Synonyms.** Two names in the change for one concept (`job` and `task`). One entry, both
  forms; the decision picks the winner.
- **Overloads.** One name for two concepts, or a name the codebase already uses with a
  different meaning. One entry per meaning, each noting the collision.
- **Metaphors.** Names whose literal sense comes from another domain (`reaper`, `hydrate`,
  `bake`, `leaf`). These are the most expensive to decode.
- **Codebase analogue.** The codebase already has a word for this concept. Record it; it is
  the strongest alternative, because adopting it costs the reader nothing new.

Group by concept, not by identifier. `Reaper`, `reap()`, `reaped_count`, and
`ReaperConfig` are one term. Order entries by cost to the reader: exported names first,
then names with the most references, then prose-only words.

## Write the glossary

Write `GLOSSARY.md` at the repository root (the worktree root when in a worktree). If a
file by that name already exists and is not lexicon output, use `GLOSSARY.lexicon.md`
instead. Never stage or commit the file.

Use this shape:

```markdown
# Lexicon: <branch or one-line change description>

Base: <sha>. Edit the `Decision` line of each entry, then tell me to apply.
`keep` accepts the term. Any other word becomes the new term. Correct the
`Meaning` line if it is wrong; a wrong meaning means the concept needs a look
before any rename.

## `Reaper`

- **Forms:** `Reaper`, `reap()`, `reaped_count`, `ReaperConfig`
- **Where:** `src/pool.rs:12`, `src/pool.rs:88`, `src/config.rs:40`, 6 more sites
- **Meaning:** The background task that closes pool connections idle longer than
  `idle_timeout`.
- **Why this word:** Borrowed from process reaping: it collects things that have
  stopped being useful.
- **Codebase analogue:** `Sweeper` in `cache/sweep.rs` does this for cache entries.
- **Externally visible:** `pool_reaped_total` metric name.
- **Alternatives:**
  - `IdleSweeper`: matches `cache/sweep.rs`; says what it removes.
  - `PoolJanitor`: plain, but the codebase does not use "janitor" anywhere.
  - `IdleConnectionCloser`: literal; longest.
- **Decision:** keep
```

Per entry:

- **Meaning** is one or two sentences. If it will not fit, the term may name two things;
  split it.
- **Why this word** is the honest rationale, including "no strong reason" when that is true.
- **Codebase analogue** appears only when one exists, and leads the alternatives.
- **Externally visible** appears only for names that leave the process: config keys,
  serialized fields, metric names, database columns, CLI flags, public API. A rename there
  has a compatibility cost; the user needs to see it before deciding.
- **Alternatives** are two to four candidates, each with a few words on the tradeoff.
- **Decision** defaults to `keep`.

## Pause

After writing, stop. Tell the user the path, the entry count, and that `keep` or a new word
on each `Decision` line is all the file needs. Apply nothing until the user says to.
Decisions given in chat are valid too, and override the file.

## Apply decisions

Read the file back. For every entry whose decision is not `keep`:

1. **Derive the forms.** A new noun needs its verb, plural, abbreviation, and casing
   variants, one for each form listed in the entry (`IdleSweeper` → `sweep()`,
   `swept_count`, `IdleSweeperConfig`). Derivation is a judgment, not a substitution; list
   the derived forms in the report so the user can object.
2. **Check collisions.** Search the whole repository for each new form with word
   boundaries. If a form already exists with a different meaning, stop and ask before
   touching anything.
3. **Rename within the changeset.** Prefer LSP rename when it is available. Otherwise use
   word-bounded search-and-replace over every derived form, including occurrences in
   comments, docstrings, tests, log messages, metric names, and config keys inside the
   changeset. Leave pre-existing code alone; when the decision adopts a codebase analogue,
   the changeset takes the existing word and the existing code is untouched.
4. **Compare corrected meanings against the code.** If the user rewrote a `Meaning` line,
   read the code again. If the code does what the user wrote, the word was wrong and the
   rename fixes it. If the code does something else, do not rename; report the gap. That is
   a concept bug surfacing, and renaming would hide it.

Work in the working tree and leave the result uncommitted unless the user asks otherwise.
If the changeset was already committed, its messages still carry the old terms; say so and
let the user choose between amend, squash, and leaving them.

## Verify

Run what the repository runs: build, tests, lint. Then search the changeset's files for
each old form with word boundaries; expect zero matches. If verification fails, restore the
affected files from before the rename and report which form broke it.

Delete `GLOSSARY.md` when everything passes, unless the user asks to keep it.

## Report

Keep it short; the diff is the deliverable.

- Applied: each old term → new term, with the derived forms.
- Kept: the terms the user accepted.
- Stopped: collisions or meaning gaps, and what was done about each.
- Verification: the command and its result.
- Commit messages that still carry old terms, if any.

## Traps

- **The codebase's words.** A term that predates the change belongs to the codebase.
  Listing it wastes the user's time; renaming it widens the diff. Check the base revision
  before listing anything.
- **Conventional words that look bespoke.** `visitor`, `sink`, `reducer`, and `middleware`
  are ordinary in their ecosystems. Skip them in a codebase that uses that ecosystem; list
  them in one that does not.
- **Partial renames.** A noun renamed in the type but not in the verb, the log line, or the
  test name leaves two vocabularies in the code. Derive every form before touching any.
- **Serialized names.** Config keys, JSON fields, metric names, and columns leak outside the
  process. Mark them in the glossary so the user decides with the cost in view.
- **Fixing the concept during the rename.** When a corrected meaning exposes that the code
  is wrong, the fix is a separate change. Report it and stop.
