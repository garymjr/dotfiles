---
name: tasks-cli
description: Local-first tasks CLI for managing project work with dependencies, tags, priorities, and status. Use when adding, editing, or organizing tasks with the `tasks` command in a repo.
---

# Tasks CLI Skill

Local-first task manager stored in `.tasks/tasks.json` per directory. Supports dependencies, tags, priorities, and lifecycle states.

## When to Use

- Managing project tasks, bugs, or features in a repo
- Organizing work with dependencies and blocked states
- Tracking task status (todo → in_progress → done)
- Filtering by tags, status, or priority

## Ideal Workflows

### Bootstrap a Repo

```bash
tasks init
tasks add "Project kickoff" --priority high --tags planning
```

### Daily Loop

```bash
tasks next
# pick one, then:
tasks edit <id> --status in_progress
# when done:
tasks done <id>
```

### Dependency-Driven Planning

```bash
tasks add "Ship v1" --priority high --tags release
PARENT=<id>

tasks add "Write changelog" --tags docs
CHILD=<id>

tasks link $CHILD $PARENT
# work ready items only:
tasks next --all
```

### Triage + Tagging

```bash
tasks list --status todo --priority high
tasks tag <id> urgent
tasks edit <id> --priority critical
```

### Review + Cleanup

```bash
tasks list --status done
tasks delete <id>
```
