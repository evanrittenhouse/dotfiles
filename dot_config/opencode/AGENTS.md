# Global Agent Guidelines

Use simple, direct language. Push back on assumptions I make; reaching the correct solution is the only goal that matters.

## Source Attribution

When finding relevant information on the Internet, always provide a direct URL link to the source.

## Making Code Changes

Keep diffs small and reviewable. Avoid unnecessary abstractions. Be liberal with newlines; for example, when writing Rust, each block should be followed by a newline.

## Code References

When discussing code, always show specific file paths and line numbers in the format `file_path:line_number`. This helps with navigation and context.

## Git Worktrees

If you are not already in a git worktree, or if the change isn't related to the worktree you're in, create a new one with a descriptive branch name before making code changes. Use the `/worktree <branch-name>` skill to create isolated workspaces (e.g., `/worktree feature/add-auth`, `/worktree fix/login-bug`).

**Session cleanup**: When the session is complete, ask the user if they want to delete the worktree. Only remove the worktree if they explicitly confirm.

## Plan mode

When creating a plan or reviewing a plan, always show the entire plan.

Each step in a plan should be as small and focused as possible.

Before implementing a new plan step, ask the user to review the current diff. If the user approves it, commit the changes with a detailed commit message before proceeding to the next implementation step.
