---
name: beads
description: Dependency-aware issue tracking with bd. Use for managing tasks, bugs, and features with automatic dependency tracking, ready work detection, and AI agent integration. Perfect for tracking work that needs to be coordinated across multiple agents or tracking blockers and dependencies.
---

# Beads - Dependency-Aware Issue Tracker

Beads (bd) is a command-line issue tracker designed for AI-supervised workflows. Issues are chained together like beads with explicit dependencies, preventing duplicate work and ensuring correct execution order.

## Setup

### Installation

Beads is a single Go binary. Install it once:

```bash
# Download and install
go install github.com/steveyegge/beads@latest

# Or download a release binary from GitHub
wget https://github.com/steveyegge/beads/releases/latest/download/bd-darwin-amd64 -O /usr/local/bin/bd
chmod +x /usr/local/bin/bd
```

### Initialize in Your Project

```bash
cd /your/project
bd init

# Or with a custom prefix (issues will be named api-1, api-2, etc.)
bd init --prefix api
```

This creates a `.beads/` directory with a SQLite database.

## Quick Reference

### Creating Issues

```bash
bd create "Fix login bug"
bd create "Add auth" -p 0 -t feature
bd create "Write tests" -d "Unit tests for auth" --assignee alice
```

**Options:**
- `-p, --priority` 0-4 (0=highest, 4=lowest)
- `-t, --type` feature, bug, chore, refactor, docs, test
- `-d, --description` Issue description
- `--assignee` Who is working on this

### Viewing Issues

```bash
bd list                           # List all issues
bd list --status open             # Filter by status
bd list --priority 0              # Filter by priority
bd show bd-1                      # Show issue details
bd ready                          # Show issues ready to work on
```

### Managing Dependencies

```bash
# Add dependency: bd-2 blocks bd-1
bd dep add bd-1 bd-2

# Remove dependency
bd dep remove bd-1 bd-2

# Visualize dependency tree
bd dep tree bd-1

# Detect circular dependencies
bd dep cycles

# List dependencies for an issue
bd dep list bd-1
```

**Dependency Types:**
- `blocks` - Task B must complete before Task A
- `related` - Soft connection, doesn't block progress
- `parent-child` - Epic/subtask hierarchical relationship
- `discovered-from` - Auto-created when AI discovers related work

### Updating Issues

```bash
bd update bd-1 --status in_progress
bd update bd-1 --priority 0
bd update bd-1 --assignee bob
bd update bd-1 --description "New description"
```

**Status values:** `open`, `in_progress`, `closed`, `blocked`

### Closing Issues

```bash
bd close bd-1
bd close bd-2 bd-3 --reason "Fixed in PR #42"
```

## Agent Workflow Guide

**IMPORTANT**: This project uses **bd (beads)** for ALL issue tracking. Do NOT use markdown TODOs, task lists, or other tracking methods.

### Why bd?

- Dependency-aware: Track blockers and relationships between issues
- Git-friendly: Auto-syncs to JSONL for version control
- Agent-optimized: JSON output, ready work detection, discovered-from links
- Prevents duplicate tracking systems and confusion

### Quick Start for Agents

**Check for ready work:**
```bash
bd ready --json
```

**Create new issues:**
```bash
bd create "Issue title" -t bug|feature|task -p 0-4 --json
bd create "Issue title" -p 1 --deps discovered-from:bd-123 --json
bd create "Subtask" --parent <epic-id> --json  # Hierarchical subtask (gets ID like epic-id.1)
```

**Claim and update:**
```bash
bd update bd-42 --status in_progress --json
bd update bd-42 --priority 1 --json
```

**Complete work:**
```bash
bd close bd-42 --reason "Completed" --json
```

### Issue Types

- `bug` - Something broken
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature with subtasks
- `chore` - Maintenance (dependencies, tooling)

### Priorities

- `0` - Critical (security, data loss, broken builds)
- `1` - High (major features, important bugs)
- `2` - Medium (default, nice-to-have)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)

### Workflow for AI Agents

1. **Check ready work**: `bd ready` shows unblocked issues
2. **Claim your task**: `bd update <id> --status in_progress`
3. **Work on it**: Implement, test, document
4. **Discover new work?** Create linked issue:
   - `bd create "Found bug" -p 1 --deps discovered-from:<parent-id>`
5. **Complete**: `bd close <id> --reason "Done"`
6. **Commit together**: Always commit the `.beads/issues.jsonl` file together with the code changes so issue state stays in sync with code state

### Auto-Sync

bd automatically syncs with git:
- Exports to `.beads/issues.jsonl` after changes (5s debounce)
- Imports from JSONL when newer (e.g., after `git pull`)
- No manual export/import needed!

### GitHub Copilot Integration

If using GitHub Copilot, also create `.github/copilot-instructions.md` for automatic instruction loading.
Run `bd onboard` to get the content, or see step 2 of the onboard instructions.

### MCP Server (Recommended)

If using Claude or MCP-compatible clients, install the beads MCP server:

```bash
pip install beads-mcp
```

Add to MCP config (e.g., `~/.config/claude/config.json`):
```json
{
  "beads": {
    "command": "beads-mcp",
    "args": []
  }
}
```

Then use `mcp__beads__*` functions instead of CLI commands.

### Managing AI-Generated Planning Documents

AI assistants often create planning and design documents during development:
- PLAN.md, IMPLEMENTATION.md, ARCHITECTURE.md
- DESIGN.md, CODEBASE_SUMMARY.md, INTEGRATION_PLAN.md
- TESTING_GUIDE.md, TECHNICAL_DESIGN.md, and similar files

**Best Practice: Use a dedicated directory for these ephemeral files**

**Recommended approach:**
- Create a `history/` directory in the project root
- Store ALL AI-generated planning/design docs in `history/`
- Keep the repository root clean and focused on permanent project files
- Only access `history/` when explicitly asked to review past planning

**Example .gitignore entry (optional):**
```
# AI planning documents (ephemeral)
history/
```

**Benefits:**
- ✅ Clean repository root
- ✅ Clear separation between ephemeral and permanent documentation
- ✅ Easy to exclude from version control if desired
- ✅ Preserves planning history for archeological research
- ✅ Reduces noise when browsing the project

### CLI Help

Run `bd <command> --help` to see all available flags for any command.
For example: `bd create --help` shows `--parent`, `--deps`, `--assignee`, etc.

### Important Rules

- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic use
- ✅ Link discovered work with `discovered-from` dependencies
- ✅ Check `bd ready` before asking "what should I work on?"
- ✅ Store AI planning docs in `history/` directory
- ✅ Run `bd <cmd> --help` to discover available flags
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems
- ❌ Do NOT clutter repo root with planning documents

## Workflow Patterns

### For AI Agents

Beads is designed for AI-supervised workflows. Use this pattern:

1. **Discover work**: Agent creates issues when discovering new work
2. **Claim ready work**: Use `bd ready` to find unblocked work
3. **Track dependencies**: Add dependencies to prevent duplication
4. **Update progress**: Update status as work progresses

```bash
# Agent checks for ready work
bd ready --json

# Claims an issue
bd update bd-1 --status in_progress --assignee agent-1

# Completes work
bd close bd-1 --reason "Implemented feature X"
```

### For Development Teams

1. **Create issues** for all work items
2. **Add dependencies** between related tasks
3. **Use bd ready** to find tasks ready to start
4. **Track progress** with status updates

### For Bug Tracking

```bash
# Create bug with high priority
bd create "Critical memory leak" -p 0 -t bug

# Create fix task that depends on investigation
bd create "Investigate memory leak" -p 0 -t bug
bd create "Fix memory leak" -p 0 -t bug
bd dep add bd-2 bd-1  # Fix depends on investigation

# Ready work shows only investigation is unblocked
bd ready
```

### For Feature Development

```bash
# Create epic
bd create "Add user authentication" -t feature -p 1

# Create subtasks
bd create "Design auth flow" -t feature -d "Create wireframes and UX specs"
bd create "Implement login API" -t feature -d "POST /auth/login endpoint"
bd create "Implement signup API" -t feature -d "POST /auth/signup endpoint"
bd create "Write auth tests" -t test

# Add parent-child relationships
bd dep add bd-2 bd-1 --type parent-child
bd dep add bd-3 bd-1 --type parent-child
bd dep add bd-4 bd-1 --type parent-child
bd dep add bd-5 bd-1 --type parent-child

# Add blocking dependencies
bd dep add bd-3 bd-2  # Implement login depends on design
bd dep add bd-4 bd-2  # Implement signup depends on design
bd dep add bd-5 bd-3  # Tests depend on implementation
bd dep add bd-5 bd-4  # Tests depend on implementation
```

## Best Practices

### Naming Conventions

- Use clear, descriptive issue titles
- Start with action verbs: "Add", "Fix", "Implement", "Refactor"
- Include context: "Fix login timeout after 30 seconds" not "Fix timeout"

### Priority Levels

| Priority | When to use |
|----------|-------------|
| 0 | Critical bugs, blockers, urgent production issues |
| 1 | High priority features, important bugs |
| 2 | Normal priority work (default) |
| 3 | Low priority, nice-to-have |
| 4 | Backlog, may never do |

### Dependency Hygiene

- Add dependencies proactively to prevent duplicate work
- Avoid over-linking - only add real blockers
- Use `related` type for soft connections
- Run `bd dep cycles` periodically to detect circular deps

### Status Workflow

```
open → in_progress → closed
  ↓
blocked (when has blocking dependencies)
```

## JSON Output for Automation

All commands support `--json` for programmatic parsing:

```bash
bd ready --json | jq '.[] | select(.priority == 0)'
bd list --status open --json | jq -r '.[] | .id'
bd show bd-1 --json | jq '.description'
```

## Database Location

Beads automatically discovers your database in this order:

1. `--db /path/to/db.db` flag
2. `$BEADS_DB` environment variable
3. `.beads/*.db` in current directory or ancestors
4. `~/.beads/default.db` as fallback

Set the database path explicitly for automation:

```bash
export BEADS_DB=/path/to/project/.beads/db.db
bd ready --json
```

## Git Integration

Beads automatically syncs with git:

- **Export**: JSONL written after CRUD operations (5s debounce)
- **Import**: JSONL imported when newer than DB (after git pull)

This works seamlessly across machines and team members. No manual export/import needed.

Disable with `--no-auto-flush` or `--no-auto-import`.

## Common Operations

### Find Blocked Issues

```bash
# Show all issues that are blocked
bd list --status blocked

# Show why an issue is blocked
bd dep tree bd-1
```

### Bulk Operations

```bash
# Create multiple issues
for task in "Task 1" "Task 2" "Task 3"; do
  bd create "$task"
done

# Close multiple issues
bd close bd-1 bd-2 bd-3 --reason "Batch complete"
```

### Clean Up Closed Issues

```bash
# List all closed issues
bd list --status closed

# Archive closed issues (manual process - export, then delete)
bd list --status closed --json > closed-backup.json
```

## Advanced: Database Extension

Applications can extend beads' SQLite database:

```sql
-- Add your own tables
CREATE TABLE IF NOT EXISTS myapp_executions (
  id INTEGER PRIMARY KEY,
  issue_id TEXT,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  FOREIGN KEY (issue_id) REFERENCES issues(id)
);
```

See [Extending Beads](https://github.com/steveyegge/beads/blob/main/EXTENDING.md) for full integration patterns.

## Troubleshooting

### Database Not Found

```bash
# Find your database
find . -name "*.db" -path "*/.beads/*"

# Or set explicitly
export BEADS_DB=/absolute/path/to/db.db
```

### Circular Dependencies

```bash
# Detect circular dependencies
bd dep cycles

# Remove one of the circular dependencies
bd dep remove bd-1 bd-2
```

### Multiple Databases

If you have multiple `.beads/` directories, specify which one:

```bash
bd --db ./frontend/.beads/frontend.db ready
bd --db ./backend/.beads/backend.db ready
```

## Example Session

```bash
# Initialize project
bd init --prefix myapp

# Create initial issues
bd create "Set up project structure" -p 0 -t chore
bd create "Implement core API" -p 1 -t feature
bd create "Write API tests" -p 2 -t test

# Add dependency: tests depend on API
bd dep add myapp-3 myapp-2

# Check ready work
bd ready
# Output: myapp-1, myapp-2 (myapp-3 is blocked by myapp-2)

# Start working
bd update myapp-1 --status in_progress

# Complete
bd close myapp-1 --reason "Project structure set up"

# Next ready task
bd ready
# Output: myapp-2 (now unblocked)
```
