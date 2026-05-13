# AGENTS.md

Most projects live under `~/Developer`.

## Top Priorities

- Use the specific tool, branch shape, or workflow the user names unless blocked.
- Preserve exact runtime shapes the user names, especially branches, container names, ports, mounts, and launch args, unless they ask to change them.
- Prefer doing obvious next steps over asking.
- Ground investigations in repo evidence and exact observed output.
- Protect secrets, PII, credentials, and production data.
- Preserve unrelated user changes in git.

## Working Style

- Keep responses concise.
- Prefer short, direct updates and compact lists only when they make the answer easier to scan.
- Make reasonable assumptions by default.
- Ask only when the choice could change behavior, data safety, or a public API.
- If the user says to implement a plan, switch from planning to execution.

## Evidence And Verification

- Include exact files, commands, observed behavior, and unresolved uncertainty when useful.
- If a run fails, inspect the live terminal or log output first and use the exact error text.
- When a toolchain command fails because of sandbox, cache, or socket limits, retry with the repo's documented wrapper or a temporary-cache workaround before changing code.
- If the requested UI path is unavailable, pivot to the real API/CLI flow and include the auth or token steps.
- When touching config, routes, schemas, generated artifacts, import paths, or docs/examples, verify adjacent references so the result can actually be used.
- Run the smallest relevant verification after code changes.
- Report what was checked and what was not.

## Security And Production Data

- For auth, PII, credentials, or production data work, keep sensitive data out of prompts, logs, persisted records, and public output.
- Prefer opaque tokens and server-side lookups.
- For production work, default to read-only unless mutation is explicitly requested or confirmed.

## Code Changes

- Add comments only for non-obvious intent, constraints, or tradeoffs.
- Do not leave breadcrumb comments when code is moved or removed.
- Keep files reasonably small; prefer helpers or modules before files become hard to scan.

## Git And Publishing

- When asked to commit, inspect status, stage intentionally, commit with an appropriate message, and verify the final status.
- When asked to commit and push after a fix, check whether the fix is already committed before creating another commit.
- Use `gh auth status` to inspect state.
- If asked to commit and push but not open a PR, stop after the push.
- If git fails with `index.lock` or permission errors, treat it as an environment boundary and retry through the repo's permission-safe path.
- If `gh` auth fails in sandbox, retry with network/keychain access before starting browser/device auth; only reauth on explicit request or a remaining missing-scope error.

## Reviews

- For code review requests, lead with findings ordered by severity.
- Include file/line evidence and keep summaries secondary.

## Infrastructure

- Do not run `terraform apply` unless explicitly requested.
- For Terraform/import work, report whether the plan changes real infrastructure or only state/outputs.
