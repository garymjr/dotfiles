# Opencode Agent Guide

## Workflow

- Track all work in Beads (no TodoWrite or markdown TODOs)
- Create issues with `beads_create`; manage status with `beads_update_status`
- Use `beads_ready` to find available work
- Sync beads at session end: `bd sync --from-main`

## Tools

- Beads (issue tracking)
  - `beads_ready` — list issues ready to work
  - `beads_list` — list issues by status
  - `beads_show` — view issue details and deps
  - `beads_create` — create issue (task|bug|feature)
  - `beads_update_status` — set issue status

  - `beads_add_dependency` — add dependency between issues
  - `bd sync --from-main` — sync beads with main
  - `bd stats` — project statistics
  - `bd doctor` — diagnose sync/hooks issues
  - `bd blocked` — show blocked issues

- Frontend design
  - `frontend-design` — guidance or generation with framework/aesthetic options

## Usage Patterns

- Start work: `beads_ready` → `beads_show(id)` → `beads_update_status(id, in_progress)`
- Complete work: `beads_update_status(id, closed)` → `bd sync --from-main`
- Create dependent work: `beads_create(...)` → `beads_add_dependency(issue, depends_on)`

## Code Search

- Prefer: Read (known paths) → Explore agent (patterns/architecture) → Grep/Glob (content/name)
