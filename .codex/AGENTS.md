# AGENTS.md

## Top Priorities

- Work style: telegraph; noun-phrases ok; drop grammar; min tokens.
- Protect secrets, PII, credentials, and production data.

## Autonomy

- If the user asks for a concrete outcome and the implementation path is clear, proceed through inspection, editing, and validation without asking for confirmation at each step.
- Make reasonable local decisions about naming, file placement, helper extraction, and test shape when the surrounding project already shows a pattern.
- When there are multiple safe implementation choices, choose the smallest one that satisfies the request and note the choice in the final summary.
- Ask only when the decision would materially affect product behavior, security posture, production data, infrastructure, dependencies, public APIs, or Git history.

## Validation Autonomy

- If a formatter, linter, typecheck, build, or focused test fails because of the current change, attempt a focused fix and rerun the relevant check without asking first.
- If validation requires directly-caused snapshot, fixture, lockfile, generated-code, or documentation updates, make those updates and report the command that produced them.
- If the failure appears unrelated to the current change, do not broaden the task; report the exact failure and the evidence that it appears pre-existing.

## Tests And Docs

- Add or update nearby tests, fixtures, snapshots, README sections, comments, or examples when they are directly needed to verify or explain the requested change.
- Update generated snapshots or lockfiles only when they are a direct consequence of the requested change and the command that produced them is reported.

## Local Commands

- Run read-only inspection commands and project-local validation commands without asking when they do not access secrets, production data, external services, or destructive operations.
- Run read-only Git inspection without asking, including `git status`, `git diff`, `git show`, `git log`, branch, remote, and blame queries.
- Prefer narrow commands first, then broaden only when needed to diagnose the current task.

## Evidence And Verification

- Include exact files, commands, observed behavior, and unresolved uncertainty when useful.
- If a run fails, inspect the live terminal or log output first and use the exact error text.
- Assume the user or another agent may have changed files mid-run; refresh context before summarizing or editing.

## Environment Variables

- Never run broad environment dumps such as `env`, `set`, or `export -p`; query exact variable names and redact values.

## Tooling

- Use `mise` to manage project runtimes and tool versions.
- If a local tool fails only because cache, scratch, or build metadata paths are blocked, retry once with a scoped `/private/tmp/...` path when that does not change product behavior, dependencies, infrastructure, secrets, or production data.
- If you use `/private/tmp` for sandbox-safe caches, scratch files, or tool output, clean up the specific files and directories you created before finishing.

## Security And Production Data

- For auth, PII, credentials, or production data work, keep sensitive data out of prompts, logs, persisted records, and public output.
- For auth, PII, credentials, and production data, prefer opaque tokens and server-side lookups over exposing raw sensitive values.
- For production work, default to read-only unless mutation is explicitly requested or confirmed.

## Code Changes

- Add comments only for non-obvious intent, constraints, or tradeoffs.
- Do not leave breadcrumb comments when code is moved or removed.
- Keep files reasonably small; prefer helpers or modules before files become hard to scan.
- Add regression tests for bug fixes when the project shape makes that reasonable.
- Use the repo's existing package manager and runtime; do not swap tooling without approval.
- Do not add new dependencies without explicit approval. Before proposing one, check maintenance, popularity, license, install/build scripts, transitive dependency footprint, and whether the project can reasonably use the standard library or an existing dependency instead.
- When reviewing changes, explicitly look for AI slop: sloppy code, vague abstractions, gratuitous complexity, inconsistent style, weak naming, untested edge cases, or changes that look plausible but do not actually fit the surrounding system.
- Fix tiny nearby papercuts only when low-risk and directly affecting the current task. Ask before broader refactors or behavior changes.

## Git

- Destructive git or filesystem operations are forbidden unless explicitly requested.
- Do not amend commits, force-push, or otherwise rewrite published history without explicit approval for that exact action.
- If already inside a git repo, work in that checkout instead of jumping to a sibling clone unless asked.

## Infrastructure

- Never run destructive Terraform or OpenTofu commands unless explicitly requested.
