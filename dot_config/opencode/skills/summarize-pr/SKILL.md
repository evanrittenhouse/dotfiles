---
name: summarize-pr
description: >-
  Summarize a GitHub pull request from a PR URL, number, or branch by gathering PR metadata,
  changed files, important diffs, tests, CI status, and reviewer-facing risk areas. Use when
  the user asks for a PR summary, wants the important files and changes explained, needs test
  coverage called out, or wants critical sections and likely review concerns such as race
  conditions, lifecycle issues, rollout risk, security, data compatibility, performance, or
  missing validation highlighted without performing a full code review.
---

# Summarize PR

## Overview

Create a reviewer-ready summary of a pull request. Focus on what changed, why the changed files matter, what was tested, and where reviewers should spend attention.

This is not a full adversarial code review. Do enough inspection to identify important sections and plausible risks, but do not approve, request changes, post comments, or modify code unless the user explicitly asks.

## Resolve the PR

Accept a GitHub PR URL, PR number, or branch name. If the target is a number and the current repository is ambiguous, ask for the repository or infer it from the current checkout.

Use `gh` for PR data. GitHub commands need network access, so request sandbox escalation when the harness requires it.

```bash
PR="$ARGUMENTS"
mkdir -p /tmp/summarize-pr
gh pr view "$PR" --json \
  number,title,body,author,state,isDraft,url,baseRefName,baseRefOid,headRefName,headRefOid,headRepository,headRepositoryOwner,isCrossRepository,additions,deletions,changedFiles,files,commits,labels,reviewRequests,latestReviews,reviewDecision,statusCheckRollup \
  > /tmp/summarize-pr/pr.json
gh pr diff "$PR" --name-only > /tmp/summarize-pr/files.txt
gh pr view "$PR" --json files --jq '.files[] | [.path, (.additions|tostring), (.deletions|tostring)] | @tsv' \
  > /tmp/summarize-pr/file-stats.tsv
gh pr diff "$PR" --patch --color=never > /tmp/summarize-pr/diff.patch
```

If the PR is too large to read in one pass, use the file list and file stats to prioritize patches. Read generated files, vendored files, lockfiles, and snapshots only after understanding the source changes that produced them.

## Inspect the Change

Build the summary from primary PR artifacts, not only the PR description.

1. Read the PR title, body, labels, commit subjects, changed-file list, and file stats.
2. Classify changed files by role: public API, core logic, lifecycle or concurrency, persistence or migrations, auth or security, infra or deployment, tests, generated artifacts, documentation.
3. Read the most important patches. Prioritize files with user-visible behavior, shared libraries, lifecycle management, goroutines or async work, locking, retries, cancellation, migrations, permissions, configuration, and deletion paths.
4. Identify tests added or changed. Capture what they cover and what risk they leave uncovered.
5. Read CI status from `statusCheckRollup`; distinguish passing, failing, pending, skipped, and missing checks.
6. If a file requires more context, inspect nearby source in the local checkout or via `gh api` before summarizing it.

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

## Risk Lens

Flag important areas to review even when you are not certain they are bugs. Label them as review focus, risk, or test gap rather than findings unless the evidence is conclusive.

Check for:

- **Race conditions**: shared mutable state, goroutines, async callbacks, event handlers, parallel tests, locks, atomics, channel closing, request cancellation.
- **Lifecycle issues**: startup and shutdown order, cleanup, ownership transfer, finalizers, subscriptions, watchers, retries, background workers, timers, context propagation.
- **Data compatibility**: migrations, schema changes, serialization formats, defaults, nil or zero-value behavior, backfills, downgrade paths.
- **Rollout and config**: feature flags, environment variables, Helm or Terraform changes, default behavior, partial deployment safety.
- **Security and privacy**: authorization checks, token handling, secret logging, tenant boundaries, path traversal, injection risk.
- **Error handling**: retry loops, idempotency, timeouts, cancellation, partial failure, observability around failures.
- **Performance**: new loops over unbounded collections, extra network calls, N+1 behavior, cache invalidation, memory ownership.
- **Tests**: missing negative tests, concurrency tests, lifecycle cleanup tests, migration tests, integration coverage, flaky timing assumptions.

## Output Shape

Use this structure unless the user asks for a different format:

```markdown
**PR Summary**
<title, PR number, author, base -> head, draft/state, size>

**Net Change**
- <2-5 bullets describing behavior and intent>

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
```

Keep summaries factual and reviewer-oriented. Avoid restating every file in the diff. Do not invent test execution; say whether evidence came from changed test files, PR text, CI checks, or commands you personally ran.
