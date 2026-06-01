# AGENTS.md

## Top Priorities

- Workspace: `~/Developer`.
- Protect secrets, PII, credentials, and production data.

## Evidence And Verification

- Include exact files, commands, observed behavior, and unresolved uncertainty when useful.
- If a run fails, inspect the live terminal or log output first and use the exact error text.
- Assume the user or another agent may have changed files mid-run; refresh context before summarizing or editing.
- If a `justfile` exists, prefer `just` targets for build/test/lint. If not, use the project's existing conventions.
- If an expected environment variable appears unset, check `mise` configuration and activation state before asking the user.

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
- Never run broad environment dumps such as `env`, `set`, or `export -p`; query exact variable names and redact values.

## Git

- Safe read-only git commands include `git status`, `git diff`, and `git log`.
- Do not run git write operations unless explicitly authorized.
- Branch changes require user consent.
- Destructive git or filesystem operations are forbidden unless explicitly requested.
- If already inside a git repo, work in that checkout instead of jumping to a sibling clone unless asked.

## Handoff

- Mention commands run, changed files, unresolved uncertainty, and any opportunistic cleanup.

## Infrastructure

- Do not run `terraform apply` unless explicitly requested.
