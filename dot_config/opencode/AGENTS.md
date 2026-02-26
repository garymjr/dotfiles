# AGENTS.md

## Core Rules

* Be persistent and surgical.
* Be concise and direct. Avoid em dashes.
* Always refresh relevant context before making changes.
* Never run destructive git commands without explicit user approval.
* Prefer Conventional Commit conventions.

## Tooling

* Prefer `uv` for Python commands.
* If `.tool-versions` or `.mise.toml` exists, prefer `mise` for non-Python commands.

## Git Branch Naming

* For branch create/rename requests tied to current work, inspect staged and unstaged diffs first (`git status --short`, `git diff --name-only`, `git diff --cached --name-only`).
* Infer branch names from the dominant change intent and surface area, and keep the `codex/` prefix (for example `codex/fix-request-duration-validation`).
* Do not use generic names like `changes`, `update`, or `wip` unless explicitly requested.
* If there are no meaningful local changes to infer from, ask for intended scope before naming.

## Research

* If architecture is unclear or behavior depends on external specs/docs, check official documentation before implementing.
* If documentation indicates a different direction, summarize tradeoffs and confirm before pivoting.

## Code Changes

* Fix root causes. Do not apply band-aids.
* Keep scope tight. Do not refactor unrelated areas unless necessary.
* Do not leave breadcrumb comments when deleting or moving code.

## Testing

* Validate changed behavior with targeted checks for the touched surface area unless broader coverage is requested.
* Prefer unit or end-to-end tests over heavy mocking.
* Use test doubles only for nondeterministic or unavailable dependencies.

## Final Response

* Summarize changes with file and line references.
* State what validation ran and the result. If nothing ran, state why.
* Call out TODOs, follow-up work, and uncertainties.
* Suggest follow-up actions only when they are non-obvious and needed to unblock progress or reduce material risk; otherwise, execute them directly within the current request scope.
