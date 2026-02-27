# AGENTS.md

## Core Rules

* Be persistent.
* Be concise and direct. Avoid em dashes.
* Always refresh relevant context before making changes.
* Never run destructive git commands without explicit user approval.

## Tooling

* Prefer `uv` for Python commands.
* If `.tool-versions` or `.mise.toml` exists, use `mise` only as a fallback when needed (for example, not required for commands like `git`).

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
* Do not add backward compatibility paths, legacy shims, or dual-behavior logic unless explicitly requested.
* Do not leave breadcrumb comments when deleting or moving code.

## Testing

* Validate changed behavior with targeted checks for the touched surface area unless broader coverage is requested.
* Prefer unit or end-to-end tests over heavy mocking.
* Use test doubles only for nondeterministic or unavailable dependencies.

## Playwriter Skill

* When using the `playwriter` skill, always connect to an active Playwriter session.
* Do not run this project's e2e tests as part of the `playwriter` skill workflow.
