# AGENTS.md

## Top Priorities

- Workspace: `~/Developer`.
- Protect secrets, PII, credentials, and production data.

## Evidence And Verification

- Include exact files, commands, observed behavior, and unresolved uncertainty when useful.
- If a run fails, inspect the live terminal or log output first and use the exact error text.
- Assume the user or another agent may have changed files mid-run; refresh context before summarizing or editing.
- If a `justfile` exists, prefer `just` targets for build/test/lint. If not, use the project's existing conventions.

## Security And Production Data

- For auth, PII, credentials, or production data work, keep sensitive data out of prompts, logs, persisted records, and public output.
- Prefer opaque tokens and server-side lookups.
- For production work, default to read-only unless mutation is explicitly requested or confirmed.

## Code Changes

- Add comments only for non-obvious intent, constraints, or tradeoffs.
- Do not leave breadcrumb comments when code is moved or removed.
- Keep files reasonably small; prefer helpers or modules before files become hard to scan.
- Before adding a new dependency, check maintenance, popularity, and API fit; confirm first if the dependency is nontrivial.
- Fix tiny nearby papercuts only when low-risk and directly affecting the current task. Ask before broader refactors or behavior changes.

## Git

- Do not run git write operations unless explicitly authorized.

## Handoff

- Mention commands run, changed files, unresolved uncertainty, and any opportunistic cleanup.

## Infrastructure

- Do not run `terraform apply` unless explicitly requested.
