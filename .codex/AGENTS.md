# AGENTS.md

## Top Priorities

- Workspace: `~/Developer`.
- Protect secrets, PII, credentials, and production data.

## Evidence And Verification

- Include exact files, commands, observed behavior, and unresolved uncertainty when useful.
- If a run fails, inspect the live terminal or log output first and use the exact error text.
- Assume the user or another agent may have changed files mid-run; refresh context before summarizing or editing.
- If a `justfile` exists, prefer `just` targets for build/test/lint. If not, use the project's existing conventions.

## Environment Variables

- Never run broad environment dumps such as `env`, `set`, or `export -p`; query exact variable names and redact values.

## Rules And Notes

- When the user asks to add a rule, add it to `~/.codex/rules/default.rules`.
- When the user asks to add a note, add it to `~/.codex/AGENTS.md`.
- When the user asks to add a local note, add it to the nearest `AGENTS.md` file for the active project.

## Secrets And 1Password

- When a command may require secret env vars, prefer `op run -- ...` so 1Password can inject configured secrets.
- Use `mise exec -- op run -- ...` only when the project relies on `mise` for the command's tool/runtime versions.
- Never print secret-bearing values; query only exact variable names and redact values in output.

## Security And Production Data

- For auth, PII, credentials, or production data work, keep sensitive data out of prompts, logs, persisted records, and public output.
- Prefer opaque tokens and server-side lookups.
- For production work, default to read-only unless mutation is explicitly requested or confirmed.

## Code Changes

- Add comments only for non-obvious intent, constraints, or tradeoffs.
- Do not leave breadcrumb comments when code is moved or removed.
- Keep files reasonably small; prefer helpers or modules before files become hard to scan.
- Add regression tests for bug fixes when the project shape makes that reasonable.
- Use the repo's existing package manager and runtime; do not swap tooling without approval.
- Before adding a new dependency, check maintenance, popularity, and API fit; confirm first if the dependency is nontrivial.
- Fix tiny nearby papercuts only when low-risk and directly affecting the current task. Ask before broader refactors or behavior changes.

## Runtime Safety

- In zsh, do not use `status` as a variable name.

## Git

- Safe read-only git commands include `git status`, `git diff`, and `git log`.
- Do not run git write operations unless explicitly authorized.
- Branch changes require user consent.
- Destructive git or filesystem operations are forbidden unless explicitly requested.
- If already inside a git repo, work in that checkout instead of jumping to a sibling clone unless asked.

## Infrastructure

- Do not run `terraform apply` unless explicitly requested.
