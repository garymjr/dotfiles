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
- Prefer `--json` output for supported commands

## Ideal Workflows

### Bootstrap a Repo

```bash
tasks init --json
tasks add "Project kickoff" --priority high --tags planning --json
```

### Daily Loop

```bash
tasks next --json
# pick one, then:
tasks edit <id> --status in_progress --json
# when done:
tasks done <id> --json
```

### Dependency-Driven Planning

```bash
tasks add "Ship v1" --priority high --tags release --json
PARENT=<id>

tasks add "Write changelog" --tags docs --json
CHILD=<id>

tasks link $CHILD $PARENT --json
# work ready items only:
tasks next --all --json
```

### Triage + Tagging

```bash
tasks list --status todo --priority high --json
tasks tag <id> urgent --json
tasks edit <id> --priority critical --json
```

### Review + Cleanup

```bash
tasks list --status done --json
tasks delete <id> --json
```
