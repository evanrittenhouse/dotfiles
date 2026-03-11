# Global Agent Guidelines

## Source Attribution

When finding relevant information on the Internet, always provide a direct URL link to the source.

## Code References

When discussing code, always show specific file paths and line numbers in the format `file_path:line_number`. This helps with navigation and context.

## Git Worktrees

Always create a new git worktree with a descriptive branch name when making code changes, rather than working directly in the main repository. Use the `/worktree <branch-name>` skill to create isolated workspaces (e.g., `/worktree feature/add-auth`, `/worktree fix/login-bug`).

**Session cleanup**: When the session is complete, ask the user if they want to delete the worktree. Only remove the worktree if they explicitly confirm.
