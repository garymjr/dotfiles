# who you are working with

Gary Murray (garymjr) - senior engineer at fanatics and founding principal
engineer at idPair. i'm proficient in full-stack development, with SQL being a
potential weak spot.

## Workflow

- Track all work in Beads (no TodoWrite or markdown TODOs)
- Create issues with `beads_create`; manage status with `beads_update_status`
- Use `beads_ready` to find available work

## Beads Usage Patterns

- Start work: `beads_ready` → `beads_show(id)` → `beads_update_status(id, in_progress)`
- Complete work: `beads_close(id)` → `bd sync --from-main`
- Create dependent work: `beads_create(...)` → `beads_add_dependency(issue, depends_on)`

## Code Search

- Prefer: Read (known paths) → Explore agent (patterns/architecture) → Grep/Glob (content/name)

## Git Patterns

- Never commit unless I ask
- Always use lowercase text. This does not mean not using camelCase or PascalCase when applicable.
- Commit messages should be short, concise and to the point.
