---
description: Review changes with parallel code-reviewer subagents
argument-hint: "[PR/branch/ref or focus guidance]"
---

Review the full local changeset against the repository's default branch by default. If the user provides a PR/MR number or link, fetch it with CLI tools first and review that. If the user provides a branch name, tag, or commit, verify it with `git rev-parse --verify <ref>^{commit}` and use that ref as the base instead of resolving the default branch. If no PR/MR or base ref is provided, resolve the exact default-branch ref by running `~/.config/scripts/git-default-branch`. If that fails, prompt the user for a branch name to diff against. Diff from the merge-base so committed, staged, and unstaged changes on the current branch are all included.

Guidance: $ARGUMENTS

Use the `subagent` tool with the `tasks` parameter to launch THREE (3) `code-reviewer` agents in PARALLEL. Give each a different focus area. If the user guidance specifies areas, use those. Otherwise default to: (1) correctness, (2) security & resilience, (3) complexity & maintainability.

Each subagent runs in its own isolated process and cannot see this conversation, so every task string must be self-contained. In each task include: the exact base ref to diff from, the instruction to diff from the merge-base, the assigned focus area, and any user guidance.

After all three complete, deduplicate their findings — keep the version with better evidence, use the higher severity when they disagree, and drop anything without a `file:line` reference. Run the project's lint/test commands yourself to catch anything the reviewers missed.

Then use the `subagent` tool again with a single `code-reviewer` agent to validate. Pass it the compiled findings, the base ref, the user guidance, and this instruction: "For each finding, read the code at the referenced file:line. Classify as **Confirmed** (provably real), **Disputed** (not supported by the code), or **Acknowledged** (real but not worth fixing). Return only Confirmed findings."

Present only Confirmed findings to the user, ranked by severity. If nothing survived validation, say so.
