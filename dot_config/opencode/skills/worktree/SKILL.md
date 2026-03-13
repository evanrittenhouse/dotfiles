---
name: worktree
description: Create, manage, and delete git worktrees for parallel AI agent workflows. Use when running multiple agents on the same repository or isolating work. Accepts branch name argument.
---

# Git Worktree Management for AI Agents

Manage isolated git worktrees for parallel AI agent workflows. Worktrees are created as sibling directories to the main repository with naming pattern `agent<N>/<branch>`.

## Arguments

This skill accepts a **branch name** argument:
- `/worktree feature-auth` - Creates/switches to worktree for branch `feature-auth`
- `/worktree fix/bug-123` - Creates/switches to worktree for branch `fix/bug-123`

## Directory Structure

Worktrees are created as siblings to the top-level git repository:

```
~/projects/
├── myrepo/                    # Main repository (or superrepo if using submodules)
├── agent1/feature-auth/       # Agent 1's worktree
├── agent2/fix-bug-123/        # Agent 2's worktree
└── agent3/refactor-api/       # Agent 3's worktree
```

## Quick Reference

| Task | Command |
|------|---------|
| Create worktree | `git worktree add -b <branch> ../<agent-dir>/<branch>` |
| List worktrees | `git worktree list` |
| Remove worktree | `git worktree remove ../<agent-dir>/<branch>` |
| Prune stale refs | `git worktree prune` |
| Find next agent slot | See workflow below |

---

## Workflows

### 1. Create a New Worktree

**IMPORTANT**: Always run from the main repository (or superrepo for submodule projects).

```bash
# Step 1: Find the top-level git directory (handles submodules)
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree 2>/dev/null || git rev-parse --show-toplevel)
cd "$TOP_LEVEL"

# Step 2: Find the next available agent slot
AGENT_NUM=1
while [ -d "../agent${AGENT_NUM}" ]; do
  AGENT_NUM=$((AGENT_NUM + 1))
done

# Step 3: Create the worktree with a new branch
BRANCH_NAME="<branch>"  # Replace with actual branch name
git worktree add -b "$BRANCH_NAME" "../agent${AGENT_NUM}/${BRANCH_NAME}"

# Step 4: Navigate to the worktree
cd "../agent${AGENT_NUM}/${BRANCH_NAME}"
```

**For an existing branch:**
```bash
git worktree add "../agent${AGENT_NUM}/${BRANCH_NAME}" "$BRANCH_NAME"
```

### 2. List All Worktrees

```bash
# From any worktree or main repo
git worktree list

# Example output:
# /Users/dev/projects/myrepo                   abc1234 [main]
# /Users/dev/projects/agent1/feature-auth      def5678 [feature-auth]
# /Users/dev/projects/agent2/fix-bug-123       ghi9012 [fix-bug-123]
```

### 3. Switch to an Existing Worktree

```bash
# Find the worktree path
git worktree list | grep "<branch-name>"

# Navigate to it
cd "../agent<N>/<branch-name>"
```

### 4. Sync Worktree with Main Branch

Keep your worktree up-to-date with the main branch to minimize merge conflicts:

```bash
# From within the worktree
git fetch origin
git rebase origin/main

# Or merge if you prefer
git merge origin/main
```

### 5. Merge Worktree Changes Back to Main

**IMPORTANT: NEVER merge worktree branches into main without explicit user confirmation.** Always ask the user before performing any merge operation.

```bash
# Preferred: Create a PR/MR from the branch (lets user review and merge)
git push -u origin <branch-name>
# Then create PR via GitHub/GitLab

# Only if user explicitly requests direct merge:
cd "$TOP_LEVEL"
git checkout main
git merge <branch-name>
```

### 6. Remove a Worktree

```bash
# From main repo
cd "$TOP_LEVEL"

# Remove the worktree (keeps the branch)
git worktree remove "../agent<N>/<branch-name>"

# Optionally delete the branch too
git branch -d <branch-name>

# Clean up any stale worktree references
git worktree prune
```

### 7. Clean Up All Agent Worktrees

```bash
cd "$TOP_LEVEL"

# List and remove all agent worktrees
for wt in $(git worktree list --porcelain | grep "^worktree" | grep "/agent[0-9]" | cut -d' ' -f2); do
  echo "Removing: $wt"
  git worktree remove "$wt"
done

# Prune stale references
git worktree prune

# Optionally remove empty agent directories
rmdir ../agent* 2>/dev/null
```

---

## Best Practices

### Naming Conventions

- **Branch names**: Use descriptive prefixes: `feature/`, `fix/`, `refactor/`, `docs/`
- **Agent directories**: Sequential numbering (`agent1`, `agent2`, etc.) ensures no conflicts
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
# Terminal 1: Agent 1 works on auth
cd ~/projects/myrepo
git worktree add -b feature-auth ../agent1/feature-auth
cd ../agent1/feature-auth
# Start agent with task...

# Terminal 2: Agent 2 works on bug fix
cd ~/projects/myrepo
git worktree add -b fix-pagination ../agent2/fix-pagination
cd ../agent2/fix-pagination
# Start agent with task...

# Terminal 3: Agent 3 works on tests
cd ~/projects/myrepo
git worktree add -b add-tests ../agent3/add-tests
cd ../agent3/add-tests
# Start agent with task...
```

### Scenario: Review and Merge Agent Work

```bash
# List what agents have been working on
git worktree list

# Check each worktree's status
for agent_dir in ../agent*/; do
  echo "=== $agent_dir ==="
  git -C "$agent_dir"/* status --short
  git -C "$agent_dir"/* log --oneline -3
done

# Merge completed work
cd ~/projects/myrepo
git checkout main
git merge feature-auth
git worktree remove ../agent1/feature-auth
```

### Scenario: Discard Failed Work

```bash
# If an agent's work isn't useful, discard it
git worktree remove --force ../agent2/fix-pagination
git branch -D fix-pagination
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
cd ../agent<N>/<branch>
git stash  # or git commit

# Option 2: Force remove (discards changes!)
git worktree remove --force ../agent<N>/<branch>
```

### Submodules in Worktrees

If your project uses submodules, initialize them in each worktree:

```bash
cd ../agent<N>/<branch>
git submodule update --init --recursive
```

### Finding the Superproject

When working with submodules, always operate from the superproject:

```bash
# This returns the superproject path, or toplevel if no superproject
TOP_LEVEL=$(git rev-parse --show-superproject-working-tree 2>/dev/null || git rev-parse --show-toplevel)
echo "Top-level repository: $TOP_LEVEL"
```
