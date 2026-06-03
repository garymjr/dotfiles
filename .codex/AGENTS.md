# AGENTS.md

## Top Priorities

- Protect secrets, PII, credentials, and production data.

## Evidence And Verification

- Include exact files, commands, observed behavior, and unresolved uncertainty when useful.
- If a run fails, inspect the live terminal or log output first and use the exact error text.
- Assume the user or another agent may have changed files mid-run; refresh context before summarizing or editing.

## Environment Variables

- Never run broad environment dumps such as `env`, `set`, or `export -p`; query exact variable names and redact values.

## Secrets And 1Password

- When a command may require secret env vars, prefer `op run -- ...` so 1Password can inject configured secrets.
- Use `mise exec -- op run -- ...` only when the project relies on `mise` for the command's tool/runtime versions.
- Never print secret-bearing values; query only exact variable names and redact values in output.

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
- Before adding a new dependency, check maintenance, popularity, and API fit. Confirm first when the dependency affects auth, secrets, production data, networking, build/release tooling, or materially expands the app's attack surface.
- When reviewing changes, explicitly look for AI slop: sloppy code, vague abstractions, gratuitous complexity, inconsistent style, weak naming, untested edge cases, or changes that look plausible but do not actually fit the surrounding system.
- Fix tiny nearby papercuts only when low-risk and directly affecting the current task. Ask before broader refactors or behavior changes.

## Git

- Destructive git or filesystem operations are forbidden unless explicitly requested.
- If already inside a git repo, work in that checkout instead of jumping to a sibling clone unless asked.

## Infrastructure

- Do not run `terraform apply` unless explicitly requested.
