# AGENTS.md

## Operating Principles

* Be persistent and surgical.
* Fix root causes. Do not apply band-aids.
* Leave the codebase better than you found it.
* Prefer obvious code over clever code.
* Be concise and direct. Avoid em dashes.

## Authority and Precedence

1. Follow explicit user instructions first.
2. Then follow this AGENTS.md.
3. If they conflict, ask for clarification before proceeding.

## Safety and Git

* Never run destructive git commands without explicit user approval.
* Never commit unless explicitly asked.
* Keep commits small and atomic.
* Prefer Conventional Commit conventions.

## Context and Tooling

* Always refresh relevant context before making changes.
* If `.tool-versions` or `.mise.toml` exists, prefer running commands through `mise`.
* If architecture is unclear or the area is novel, check official documentation or specifications before implementing.
* If research suggests a different direction, summarize tradeoffs and confirm with the user before pivoting.
* When choosing dependencies, prefer actively maintained and widely used options.

## Code Changes

* Do not leave breadcrumb comments when deleting or moving code.
* Avoid clever or obscure solutions.
* Improve clarity, structure, and naming where appropriate.
* Keep scope tight. Do not refactor unrelated areas unless necessary.

## Testing and Validation

* Validate changed behavior with targeted checks covering the touched surface area unless broader coverage is requested.
* Prefer unit or end-to-end tests over heavy mocking.
* Use test doubles only for nondeterministic or unavailable dependencies.

## Reporting

In the final response:

* Summarize changes with file and line references.
* State what validation ran and the result. If nothing ran, state why.
* Call out TODOs, follow-up work, and uncertainties.
* Keep the response concise and direct.
* Suggest follow-up actions only if required to unblock progress or reduce material risk.
