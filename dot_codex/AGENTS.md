# AGENTS.md

## Scope

Applies to all Codex tasks in this repo.

## Priority

1. Follow explicit user instructions.
2. Then follow this file.
3. If instructions conflict or are ambiguous, ask once, then proceed with the safest minimal change.

## Hard Rules (MUST)

- Assume other agents or the user may change files during the task, refresh context before editing or summarizing.
- If a command runs longer than 5 minutes, stop it, capture output, and check with the user.
- Treat existing git diffs as read-only unless the user explicitly asks to modify them.
- Do not run destructive git commands unless explicitly requested.
- If `.tool-versions` or `.mise.toml` exists, prefer running commands through `mise`.
- If unsure how CI runs checks, read `.github/workflows`.
- Do not ask for `SENTRY_AUTH_TOKEN`, assume it exists and report if missing.
- If given a Sentry issue URL, do not require `SENTRY_ORG` or `SENTRY_PROJECT`.
- Do not add dependencies without user confirmation.
- Do not leave breadcrumb comments when moving or deleting code.
- Always use the `python3` binary when running Python scripts.

## Defaults (SHOULD)

- Prefer the simplest correct solution.
- Fix root causes, not symptoms.
- Keep changes scoped to the task.
- Commit often, keep commits small and easy to review.
- Clean up dead code in touched areas when low risk.
- Write idiomatic, maintainable, obvious code.

## Research Triggers

- If architecture is unclear or the area is novel, research official docs/specs before implementation.
- If research suggests a new direction, summarize tradeoffs and confirm with the user before pivoting.
- For dependency selection, choose actively maintained, widely used options with good APIs.

## Testing

- Prefer unit or e2e tests over mocks.
- Use test doubles only when dependencies are nondeterministic or unavailable.
- Test changed paths and affected behavior.
- Unless asked otherwise, run only tests for the changed surface area.

## Output Contract

- Summarize changes with file and line references.
- Call out TODOs, follow-up work, and uncertainties.
- Mention testing only when tests were added in the PR, state what ran and passed.
- Never say tests were not run because you were not asked to run them.
- Do not propose follow-up tasks or enhancements at the end of the final answer. If a follow-up is clearly needed and feasible, do it instead of asking.

## Communication Style

- Telegraph style, concise, direct.
- Dry humor is fine, avoid flattery and memes.
- Avoid em dashes, prefer commas, parentheses, or periods.
