---
name: worktree
description: Create, manage, and delete git worktrees for parallel AI agent workflows. Use when running multiple agents on the same repository or isolating work. Accepts branch name argument.
---

# Git Worktree Management for AI Agents

Manage isolated git worktrees for parallel AI agent workflows. Worktrees live under `~/Documents/projects/worktrees/<project-name>/<branch-name>`, where `<project-name>` matches the repository name and `<branch-name>` uses the form `<agent>+<descriptive-name>`.

## Arguments

This skill accepts a **branch name** argument in the form `<agent>+<descriptive-name>`:
- `/worktree opencode+feature-auth` - Creates/switches to worktree for branch `opencode+feature-auth`
- `/worktree reviewer+fix-bug-123` - Creates/switches to worktree for branch `reviewer+fix-bug-123`

Use hyphens in the descriptive segment. Avoid `/` so the branch name and worktree directory stay identical.

## Directory Structure

Worktrees are created in `~/Documents/projects/worktrees/<project-name>/`, where `<project-name>` is the basename of the top-level repository (or superproject for submodules).

```text
~/Documents/projects/worktrees/
├── sandboxes/
│   ├── opencode+feature-auth/
│   └── reviewer+fix-pagination/
└── chezmoi/
    └── opencode+update-worktree-skill/
```

The worktree directory name must exactly match the branch name.

## Quick Reference

| Task | Command |
|------|---------|
| Create worktree | `git worktree add -b <branch> "$HOME/Documents/projects/worktrees/<project>/<branch>"` |
| List worktrees | `git worktree list` |
| Remove worktree | `git worktree remove "$HOME/Documents/projects/worktrees/<project>/<branch>"` |
| Prune stale refs | `git worktree prune` |
| Derive project/worktree path | See workflow below |

---

## Workflows

### 1. Create a New Worktree

**IMPORTANT**: Always run from the main repository (or superrepo for submodule projects).

```bash
# Step 1: Find the top-level git directory (handles submodules)
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree)
if [ -z "$TOP_LEVEL" ]; then
  TOP_LEVEL=$(git rev-parse --show-toplevel)
fi
cd "$TOP_LEVEL"

# Step 2: Build the project-specific worktree path
PROJECT_NAME=$(basename "$TOP_LEVEL")
WORKTREE_ROOT="$HOME/Documents/projects/worktrees/$PROJECT_NAME"

# Step 3: Create the worktree with a new branch
BRANCH_NAME="<agent>+<descriptive-name>"  # Example: opencode+feature-auth
WORKTREE_PATH="$WORKTREE_ROOT/$BRANCH_NAME"

mkdir -p "$WORKTREE_ROOT"
git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH"

# Step 4: Navigate to the worktree
cd "$WORKTREE_PATH"
```

**For an existing branch:**
```bash
mkdir -p "$WORKTREE_ROOT"
git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
```

### 2. List All Worktrees

```bash
# From any worktree or main repo
git worktree list

# Example output:
# /Users/dev/projects/myrepo                                                abc1234 [main]
# /Users/dev/Documents/projects/worktrees/myrepo/opencode+feature-auth     def5678 [opencode+feature-auth]
# /Users/dev/Documents/projects/worktrees/myrepo/reviewer+fix-bug-123      ghi9012 [reviewer+fix-bug-123]
```

### 3. Determine Whether You're in a Worktree

Use `git rev-parse --git-dir` together with `git rev-parse --git-common-dir`:

```bash
GIT_DIR=$(git rev-parse --git-dir)
COMMON_DIR=$(git rev-parse --git-common-dir)

if [ "$GIT_DIR" = "$COMMON_DIR" ]; then
  echo "You are in the main working tree"
else
  echo "You are in a linked worktree"
fi
```

Typical output patterns:

- Main working tree: both commands return the same path, often `.git`
- Linked worktree: `--git-dir` points to `.git/worktrees/<branch-name>` while `--git-common-dir` points to the main repo's `.git`

**Important**: `git rev-parse --is-inside-work-tree` only tells you whether you are inside any Git working tree. It does **not** tell you whether that working tree is the main checkout or a linked worktree.

### 4. Switch to an Existing Worktree

```bash
# Find the worktree path
git worktree list | grep "<branch-name>"

# Navigate to it
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree)
if [ -z "$TOP_LEVEL" ]; then
  TOP_LEVEL=$(git rev-parse --show-toplevel)
fi
PROJECT_NAME=$(basename "$TOP_LEVEL")
BRANCH_NAME="<agent>+<descriptive-name>"

cd "$HOME/Documents/projects/worktrees/$PROJECT_NAME/$BRANCH_NAME"
```

### 5. Sync Worktree with Main Branch

Keep your worktree up-to-date with the main branch to minimize merge conflicts:

```bash
# From within the worktree
git fetch origin
git rebase origin/main

# Or merge if you prefer
git merge origin/main
```

### 6. Merge Worktree Changes Back to Main

**IMPORTANT: NEVER merge worktree branches into main without explicit user confirmation.** Always ask the user before performing any merge operation.

```bash
# Preferred: Create a PR/MR from the branch (lets user review and merge)
git push -u origin <branch-name>
# Then create PR via GitHub/GitLab

# Only if user explicitly requests direct merge:
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree)
if [ -z "$TOP_LEVEL" ]; then
  TOP_LEVEL=$(git rev-parse --show-toplevel)
fi
cd "$TOP_LEVEL"
git checkout main
git merge <branch-name>
```

### 7. Remove a Worktree

```bash
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree)
if [ -z "$TOP_LEVEL" ]; then
  TOP_LEVEL=$(git rev-parse --show-toplevel)
fi
PROJECT_NAME=$(basename "$TOP_LEVEL")
BRANCH_NAME="<agent>+<descriptive-name>"
WORKTREE_PATH="$HOME/Documents/projects/worktrees/$PROJECT_NAME/$BRANCH_NAME"

# From main repo
cd "$TOP_LEVEL"

# Remove the worktree (keeps the branch)
git worktree remove "$WORKTREE_PATH"

# Optionally delete the branch too
git branch -d "$BRANCH_NAME"

# Clean up any stale worktree references
git worktree prune

# Optionally remove the project directory if it's empty
rmdir "$HOME/Documents/projects/worktrees/$PROJECT_NAME" 2>/dev/null || true
```

### 8. Clean Up All Worktrees for a Project

```bash
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree)
if [ -z "$TOP_LEVEL" ]; then
  TOP_LEVEL=$(git rev-parse --show-toplevel)
fi
PROJECT_NAME=$(basename "$TOP_LEVEL")
PROJECT_WORKTREE_ROOT="$HOME/Documents/projects/worktrees/$PROJECT_NAME"

cd "$TOP_LEVEL"

for wt in "$PROJECT_WORKTREE_ROOT"/*; do
  [ -d "$wt" ] || continue
  echo "Removing: $wt"
  git worktree remove "$wt"
done

# Prune stale references
git worktree prune

# Optionally remove the empty project directory
rmdir "$PROJECT_WORKTREE_ROOT" 2>/dev/null || true
```

---

## Best Practices

### Naming Conventions

- **Branch names**: Always use `<agent>+<descriptive-name>`, for example `opencode+feature-auth`
- **Descriptive segment**: Use lowercase hyphenated words and avoid `/`
- **Project directories**: Use the top-level repository name, such as `sandboxes` or `chezmoi`
- **Keep branches short-lived**: Merge or discard within hours/days, not weeks

### Environment Setup

If the project requires setup (dependencies, environment variables), create a setup script:

```bash
# In the worktree, run project setup
npm install          # or pnpm install, yarn, etc.
./scripts/setup.sh   # project-specific setup
```

### Avoiding Merge Conflicts

1. **Sync frequently**: Rebase on main regularly
2. **Small, focused changes**: Each worktree should tackle one task
3. **Communicate**: If multiple agents touch the same files, coordinate

### Resource Management

- **Disk space**: Worktrees share `.git` but duplicate working files
- **Port conflicts**: Assign different ports if running dev servers
- **Build caches**: May need separate caches per worktree

---

## Common Scenarios

### Scenario: Run Multiple Agents in Parallel

```bash
# Terminal 1: Agent works on auth
cd ~/projects/myrepo
mkdir -p "$HOME/Documents/projects/worktrees/myrepo"
git worktree add -b opencode+feature-auth \
  "$HOME/Documents/projects/worktrees/myrepo/opencode+feature-auth"
cd "$HOME/Documents/projects/worktrees/myrepo/opencode+feature-auth"
# Start agent with task...

# Terminal 2: Agent works on bug fix
cd ~/projects/myrepo
mkdir -p "$HOME/Documents/projects/worktrees/myrepo"
git worktree add -b fixer+fix-pagination \
  "$HOME/Documents/projects/worktrees/myrepo/fixer+fix-pagination"
cd "$HOME/Documents/projects/worktrees/myrepo/fixer+fix-pagination"
# Start agent with task...

# Terminal 3: Agent works on tests
cd ~/projects/myrepo
mkdir -p "$HOME/Documents/projects/worktrees/myrepo"
git worktree add -b tester+add-auth-tests \
  "$HOME/Documents/projects/worktrees/myrepo/tester+add-auth-tests"
cd "$HOME/Documents/projects/worktrees/myrepo/tester+add-auth-tests"
# Start agent with task...
```

### Scenario: Review and Merge Agent Work

```bash
# List what agents have been working on
git worktree list

PROJECT_WORKTREE_ROOT="$HOME/Documents/projects/worktrees/myrepo"

# Check each worktree's status
for wt in "$PROJECT_WORKTREE_ROOT"/*; do
  [ -d "$wt" ] || continue
  echo "=== $wt ==="
  git -C "$wt" status --short
  git -C "$wt" log --oneline -3
done

# Merge completed work
cd ~/projects/myrepo
git checkout main
git merge opencode+feature-auth
git worktree remove "$PROJECT_WORKTREE_ROOT/opencode+feature-auth"
```

### Scenario: Discard Failed Work

```bash
# If an agent's work isn't useful, discard it
git worktree remove --force "$HOME/Documents/projects/worktrees/myrepo/fixer+fix-pagination"
git branch -D fixer+fix-pagination
git worktree prune
```

---

## Troubleshooting

### Error: "branch is already checked out"

A branch can only be checked out in one worktree at a time:

```bash
# Find where the branch is checked out
git worktree list | grep <branch-name>

# Either remove that worktree or use a different branch name
```

### Error: "worktree is dirty"

The worktree has uncommitted changes:

```bash
# Option 1: Commit or stash changes first
cd "$HOME/Documents/projects/worktrees/<project-name>/<branch-name>"
git stash  # or git commit

# Option 2: Force remove (discards changes!)
git worktree remove --force "$HOME/Documents/projects/worktrees/<project-name>/<branch-name>"
```

### Submodules in Worktrees

If your project uses submodules, initialize them in each worktree:

```bash
cd "$HOME/Documents/projects/worktrees/<project-name>/<branch-name>"
git submodule update --init --recursive
```

### Finding the Superproject

When working with submodules, always operate from the superproject:

```bash
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree)
if [ -z "$TOP_LEVEL" ]; then
  TOP_LEVEL=$(git rev-parse --show-toplevel)
fi
echo "Top-level repository: $TOP_LEVEL"
```
