---
name: fix-rebase-conflicts
description: Resolve git rebase, merge, and cherry-pick conflicts. Auto-resolves trivial conflicts (whitespace, lockfiles, import ordering, identical changes) and flags every non-trivial conflict for user review with a proposed resolution before continuing. Use when a rebase, merge, or cherry-pick stops with conflicts, or the user says "fix the conflicts", "resolve rebase conflicts", "continue the rebase".
---

# Fix Rebase Conflicts

Resolve conflicts from `git rebase`, `git merge`, or `git cherry-pick`. Auto-resolve trivial conflicts. Flag every non-trivial conflict for user review with a proposed resolution.

**NEVER continue past a non-trivial conflict without explicit user approval. When classification is uncertain, treat the conflict as non-trivial.**

## 1. Detect state

```bash
git status
git diff --name-only --diff-filter=U
```

Determine the operation:

| Operation | Indicator |
|-----------|-----------|
| rebase | `.git/rebase-merge/` or `.git/rebase-apply/` exists |
| merge | `.git/MERGE_HEAD` exists |
| cherry-pick | `.git/CHERRY_PICK_HEAD` exists |

If no operation is in progress and the user wants a rebase performed, start it (`git rebase <upstream>`) and handle stops as they occur.

### ours/theirs is SWAPPED during rebase

| Stage | merge / cherry-pick | rebase |
|-------|--------------------|--------|
| `:2` (ours) | your branch | the branch you are rebasing ONTO (upstream) |
| `:3` (theirs) | incoming branch/commit | YOUR commit being replayed |

Getting this backwards silently discards the wrong side. Confirm orientation before resolving anything.

### Inspect a conflict

```bash
git show :1:<file>    # merge base
git show :2:<file>    # ours
git show :3:<file>    # theirs
git diff <file>       # combined conflict diff
git rebase --show-current-patch   # the commit currently being replayed
git log --oneline --left-right HEAD...REBASE_HEAD -- <file>   # commits touching the file on each side
```

## 2. Classify each conflict

Classify per hunk, not per file. A file can contain both kinds.

### Trivial — auto-resolve, then report

- Whitespace or formatting-only: the two sides are identical under `git diff --ignore-all-space`
- Both sides made the identical change
- Import/include/use ordering only, with no additions that could interact
- Generated files (lockfiles: `Cargo.lock`, `package-lock.json`, `go.sum`, `poetry.lock`, `pnpm-lock.yaml`, etc.): take either side, then regenerate with the project tooling. Never hand-merge markers in generated files.
- Both sides appended distinct entries to a list-like location (changelog, registration list) and both clearly belong: keep both, order sensibly
- Pure version-string bumps: take the higher version

### Non-trivial — flag for review

- Both sides changed the same logic differently
- Delete/modify (`DU`/`UD`), both-added (`AA`), or a rename is involved
- Conflicts in control flow, error handling, locking/concurrency, security-relevant code, or tests
- Any hunk where the correct result requires understanding the intent of either commit
- A trivial-looking hunk in a file where the two sides' changes may interact semantically

If `rerere` pre-resolved a conflict, review that resolution with the same rubric before trusting it.

## 3. Resolve

**Trivial:** edit the file, remove all markers, `git add <file>`. Regenerate lockfiles with tooling (`cargo check`, `npm install --package-lock-only`, `go mod tidy`, ...) rather than editing them.

**Non-trivial:** for each conflict, present to the user:

1. `file:line`, operation, and the commits involved (subject lines from both sides)
2. Both sides of the conflict, plus the base version when it clarifies intent
3. A proposed resolution with reasoning

Then ask for approval with the question tool. Offer at minimum: accept the proposal, take ours, take theirs, or user resolves manually. Only after approval: apply the resolution and `git add <file>`.

## 4. Continue and loop

Once every conflicted file in the current stop is staged:

```bash
GIT_EDITOR=true git rebase --continue      # or: git merge --continue / git cherry-pick --continue
```

A rebase can stop again on later commits. Repeat detection, classification, and resolution at every stop until the operation completes.

## 5. Verify

- No leftover markers: `git diff --check` and search for `<<<<<<<`
- Run the project's build/tests if available
- For a completed rebase, compare old vs new history: `git range-diff <onto> ORIG_HEAD HEAD` (`<onto>` is the branch rebased onto, e.g. `origin/main`). Flag any commit whose diff changed beyond the expected conflict resolutions.

## Rules

- Never `git rebase --skip`
- Never blanket-apply `git checkout --ours`/`--theirs` across files without per-hunk classification
- Never abort the operation without asking
- Never force-push without an explicit request

## Final report

End with a summary table:

| File | Conflict | Classification | Resolution |
|------|----------|----------------|------------|
| src/foo.rs:42 | both modified retry logic | non-trivial | user-approved: merged both |
| Cargo.lock | lockfile | trivial | regenerated |
