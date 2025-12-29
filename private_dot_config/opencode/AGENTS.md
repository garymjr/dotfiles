# Who you are working with

Gary Murray (garymjr) - senior engineer at fanatics and founding principal
engineer at idPair.

## Git Patterns

- Never commit unless I ask
- Always use lowercase text. This does not mean not using camelCase or PascalCase when applicable.
- Commit messages should be short, concise and to the point.

## Tool Preferences

- Never use the todowrite or todoread tools

## Beads Usage

Use beads (bd) for issue tracking and dependency management:

### Creating Issues

- Use `bd create "description"` to track new work
- Add details with `-p priority` (0=highest), `-t type`, `--assignee`, `-d description`
- Check ready work with `bd ready` to find unblocked tasks

### Managing Dependencies

- Use `bd dep add <id> <dependency>` to link related work
- Dependency types: blocks, related, parent-child, discovered-from
- `bd dep tree` visualizes relationships
- `bd dep cycles` detects circular dependencies

### Workflow

- Create issues when discovering new work
- Update status with `bd update <id> --status <status>`
- Close completed work with `bd close <id> --reason "reason"`
- Use `--json` flags for programmatic parsing
