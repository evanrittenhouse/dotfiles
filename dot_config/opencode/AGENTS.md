# Global Agent Guidelines

Use simple, direct language. BE CONCISE; never use superfluous adjectives or run-on sentences. Push back on assumptions I make; reaching the correct solution is the only goal that matters.

## Comments

Avoid long-winded comment chains. Comments should only explain WHY we do something, in concise, terse prose, rather than re-explaining what the code already does. 

## Source Attribution

When finding relevant information on the Internet, always provide a direct URL link to the source.

## Making Code Changes

Always keep diffs small and reviewable. Avoid unnecessary abstractions. Be liberal with newlines; for example, when writing Rust, each block should be followed by a newline.

Avoid free functions when a function takes a parameter that is a member of a class, struct, or similar type. In that case, make the function a member of that type instead.

Avoid adding single-statement helper functions. Prefer inlining where possible. 

Commit messages must be 72 characters or less per line.

## Code References

When discussing code, always show specific file paths and line numbers in the format `file_path:line_number`. This helps with navigation and context.

## Git Worktrees

If you are not already in a git worktree, or if the change isn't related to the worktree you're in, create a new one with a descriptive branch name before making code changes. Use the `/worktree <branch-name>` skill to create isolated workspaces (e.g., `/worktree feature/add-auth`, `/worktree fix/login-bug`).

**Session cleanup**: When the session is complete, ask the user if they want to delete the worktree. Only remove the worktree if they explicitly confirm. When removing a worktree, also remove the associated branch.

## Plan mode

### Implementation After Plan Approval

After a plan is approved, implement it in small, reviewable steps.

For each implementation step:

- Restate the exact step being implemented before changing files.
- Make only the smallest necessary change for that step.
- Do not broaden scope without asking first.
- Verify the change before moving on when verification is feasible.
- Show the current diff after the step is complete.
- Ask the user to review the diff before continuing.
- If the user approves, commit with a detailed commit message before starting the next step.

Do not skip verification unless the user explicitly says to.

