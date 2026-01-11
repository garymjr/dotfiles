---
name: mind
description: Zig-based CLI tool for managing project todos with dependencies and tags. Use when tracking tasks, features, bugs, or any work that requires dependency tracking and organization.
---

# Mind CLI Skill

Mind is a Zig-based CLI tool for managing project todos with dependencies and tags. Store all project work in `.mind/mind.json` (gitignored).

## When to Use

- Managing project todos, features, or bugs
- Tracking work that has dependencies or blockers
- Organizing tasks with tags (epics, areas, priorities)
- Coordinating work across multiple agents
- Any task-based project work

## Core Concepts

- **ID**: `{basename}-{hex_seq}` format, auto-generated (e.g., `mind-a`, `mind-ff`, `mind-123`)
- **Status**: `pending`, `in-progress`, `done`, `blocked`
- **Priority**: `low`, `medium`, `high`, `critical` (default: medium)
- **Dependencies**: `depends_on` (parent tasks) and `blocked_by` (child tasks)
- **Tags**: Comma-separated for categorization

## Common Commands

### Adding Tasks

```bash
mind add "Implement feature"          # Simple todo (priority: medium)
mind add "Fix bug" --tags "bug,urgent" # With tags
mind add "Fix bug" --tag "bug,urgent"  # Same as --tags (alias)
mind add "Fix bug" -t "bug,urgent"    # Same as --tags (short alias)
mind add "Critical issue" --priority critical  # With priority
mind add "Task with details" --body "Description here" --tags "frontend"
mind add "Quick task" --quiet         # Output only the ID (for scripting)
```

#### Getting the ID Programmaticaly

Use `--quiet` to get just the ID for capture in scripts:

```bash
ID=$(mind add "New task" --quiet)
# $ID now contains: mind-a
mind edit $ID --status in-progress
```

### Viewing Tasks

```bash
mind list                              # List all
mind list --status pending             # Filter by status
mind list --priority critical          # Filter by priority
mind list --tags bug                  # Filter by tag
mind list --tag bug                    # Same as --tags (alias)
mind list -t bug                       # Same as --tags (short alias)
mind list --sort priority             # Sort by priority (critical first)
mind search "query"                    # Search by text (title/body)
mind search --tags frontend "auth"    # Combined filters
mind search --tag frontend "auth"     # Same as --tags (alias)
mind show <id>                         # Show details
mind status                            # Show project status summary
mind next                              # Show next ready task
```

#### Search

Search performs case-insensitive substring matching across titles and bodies (query required):

```bash
mind search "auth"                     # Find todos containing "auth"
mind search "API"                      # Find API-related todos
mind search --tags frontend "auth"     # Search with tag filter
mind search --tag frontend "auth"      # Same as --tags (alias)
mind search "bug" --json               # Search with JSON output
```

**Use cases:**
- Finding related tasks by keyword
- Locating bugs by description
- Filtering by topic + tag combination
- Quick discovery without remembering IDs

#### JSON Output

Most viewing commands support `--json` for programmatic access:

```bash
mind list --json                       # JSON array of todos
mind search "query" --json             # Search results as JSON
mind show <id> --json                  # Single todo as JSON
mind status --json                     # Status summary as JSON
mind next --json                       # Unblocked todos as JSON
mind done <id> --json                  # Mark done, return result as JSON
```

### Managing Tasks

```bash
mind edit <id> --title "New title"              # Update title
mind edit <id> --body "More details"             # Update body
mind edit <id> --status in-progress              # Update status
mind edit <id> --priority high                  # Update priority
mind edit <id> --tags "priority,urgent"          # Replace all tags
mind edit <id> --tag "priority,urgent"           # Same as --tags (alias)
mind edit <id> -t "priority,urgent"             # Same as --tags (short alias)
mind tag <id> <tag>                              # Add a single tag
mind untag <id> <tag>                            # Remove a single tag
mind done <id>                                    # Mark as done (single ID only)
mind done <id> --json                             # Mark done, JSON output
```

### Deleting Tasks

```bash
mind delete <id>                    # Fails if has dependencies
mind delete <id> --unlink           # Remove dependencies, delete this todo only
mind delete <id> --force            # Delete this todo and all linked todos
mind delete <id> --force --yes      # Skip confirmation (dangerous)
mind remove <id> --unlink           # Alias for delete
```

**Important**: `--force` cascades through all linked todos transitively. Use `--unlink` to safely delete a single todo by removing its dependencies first.

### Tag Operations

**Setting/replacing tags** (use `edit` with tag flags):
```bash
mind edit <id> --tags "bug,urgent"     # Replace all tags with new list
mind edit <id> --tag "bug,urgent"      # Same as --tags (alias)
mind edit <id> -t "bug,urgent"         # Same as --tags (short alias)
```

**Adding/removing single tags** (use `tag`/`untag` commands):
```bash
mind tag <id> urgent                  # Add single tag (appends)
mind untag <id> urgent                # Remove single tag
```

**Filtering by tags**:
```bash
mind list --tags bug                  # Filter by tag(s) - comma-separated
mind list --tag bug                   # Same as --tags (alias)
mind list -t bug                      # Same as --tags (short alias)
mind search --tags bug,frontend "API" # Search + tag filter
```

**Note**: `--tags`, `--tag`, and `-t` are all equivalent. They accept comma-separated tags and work for both setting (add/edit) and filtering (list/search). The `tag` and `untag` commands add/remove a single tag without replacing others.

### Archiving Completed Tasks

```bash
mind archive                                      # Archive done todos older than 30 days
mind archive --days 60                           # Archive done todos older than 60 days
mind archive --dry-run                           # Preview what would be archived
```

Archive moves completed todos to `.mind/archive.json` to keep your active view clean while preserving history. Only `done` todos are archived, based on when they were last updated (marked done).

## Dependency Management

### Creating Dependencies

```bash
# Parent task first
PARENT=$(mind add "Parent task")
# Note: Use the ID returned from the add command

# Child task that depends on parent
mind add "Child task"
mind link <child-id> <parent-id>
```

### Removing Dependencies

```bash
# Remove a dependency link
mind unlink <child-id> <parent-id>
```

### Dependency Relationships

- `depends_on`: Tasks this depends on (parents)
- `blocked_by`: Tasks that depend on this (children, auto-populated)

### Finding Ready Work

```bash
mind next                              # Show next ready task (no dependencies)
mind next --all                        # Show all ready tasks
mind list --unblocked                  # Show only unblocked tasks
# Use show to see dependencies
mind show <id>                         # Shows depends_on and blocked_by
```

**`mind next`** displays the next task that's ready to work on - a pending task with no unmet dependencies. Useful for quickly finding what to start next without scanning the full list.

## Best Practices

1. **Granular tasks**: Break down work into small, completable items
2. **Use tags**: Organize by area, type (e.g., `frontend`, `bug`)
3. **Set priorities**: Use `priority` field for importance (`--priority critical` for blockers)
4. **Set dependencies**: Clearly define what blocks what
5. **Update status**: Mark `in-progress` when starting, `done` when complete
6. **Clear titles**: Keep titles under 100 chars, descriptive
7. **Use body**: Add details, acceptance criteria, notes

## Unicode Normalization

Mind automatically normalizes Unicode text to NFC (Canonical Composition) form. This ensures that different Unicode representations of the same character are treated identically:

- **Tags**: `café` (precomposed) and `cafe\u0301` (decomposed) are stored as the same tag
- **Titles**: Normalized on input, ensuring consistent storage and filtering
- **Filtering**: Tag filters work regardless of Unicode representation

Example:
```bash
# These create todos with equivalent tags
mind add "Task 1" --tags café          # Precomposed
mind add "Task 2" --tags "cafe\u0301"  # Decomposed (e + combining acute)

# Both tags normalize to "café" and match when filtering
mind list --tag café
mind list --tag "cafe\u0301"  # Same results
```

## Workflows

### Starting New Feature

```bash
# 1. Add epic/task
EPIC_ID=$(mind add "Feature: User authentication" --tags "feature,auth" --quiet)

# 2. Add subtasks
DESIGN=$(mind add "Design login form" --tags "design" --quiet)
API=$(mind add "Implement login API" --tags "backend" --quiet)
UI=$(mind add "Create login UI" --tags "frontend" --quiet)
TEST=$(mind add "Write tests" --tags "testing" --quiet)

# 3. Create dependencies
mind link $DESIGN $EPIC_ID
mind link $API $DESIGN
mind link $UI $API
mind link $TEST $API
```

### Daily Workflow

```bash
# Check project status
mind status                            # See overall progress

# Check what's ready
mind next                              # Show next ready task
mind list --status pending             # See all pending tasks

# Start working
mind edit <id> --status in-progress

# When done
mind done <id>

# Check what unblocked
mind next                              # Find next task
```

### Bug Fix Workflow

```bash
# Add bug
BUG=$(mind add "Fix: Login validation error" --tags "bug,urgent" --quiet)

# If blocked by investigation, add dependency
INVESTIGATE=$(mind add "Investigate root cause" --quiet)
mind link $BUG $INVESTIGATE

# Once investigated
mind done $INVESTIGATE
mind edit $BUG --status in-progress

# Tag with more context as needed
mind tag $BUG security
mind untag $BUG urgent
```

## Testing

```bash
just test              # Test all
just test-file <file>  # Test specific file
just check             # Build + test
```

## JSON Output Formats

### `status --json`

```json
{
  "total": 10,
  "by_status": {
    "pending": 5,
    "in_progress": 2,
    "done": 3
  },
  "blocking_state": {
    "blocked": 2,
    "ready": 3
  },
  "progress_percent": 30.0
}
```

### `next --json`

```json
{
  "todos": [
    {
      "id": "mind-a",
      "title": "Task name",
      "status": "pending",
      "priority": "high"
    }
  ],
  "count": 1
}
```

### `done --json`

```json
{
  "id": "mind-a",
  "status": "done"
}
```

## Storage

Data stored in `.mind/mind.json`:

```json
{
  "todos": [{
    "id": "mind-a",
    "title": "...",
    "body": "...",
    "status": "pending",
    "priority": "medium",
    "tags": ["tag"],
    "depends_on": ["parent-id"],
    "blocked_by": ["child-id"],
    "created_at": "1736205028",
    "updated_at": "1736205028"
  }]
}
```

File is gitignored. Don't commit it.

## Getting Help

```bash
mind --help                     # General help
mind help [command]              # Help for specific command
```
