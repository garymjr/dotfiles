# AGENTS.md

## Working Style

Keep responses concise. Prefer short, direct updates and compact lists only when they make the answer easier to scan.
Make reasonable assumptions by default. Ask only when the choice could change behavior, data safety, or a public API.
Do obvious follow-up steps without asking. Ask only when the next step is ambiguous, risky, or user-facing.

## Evidence And Verification

For investigations and planning, ground the answer in repo evidence. Include exact files, commands, observed behavior, and unresolved uncertainty when useful.
When touching config, routes, schemas, generated artifacts, import paths, or docs/examples, verify adjacent references so the result can actually be used.
Run the smallest relevant verification after code changes. Report what was checked and what was not.

## Security And Production Data

For auth, PII, credentials, or production data work, keep sensitive data out of prompts, logs, persisted records, and public output. Prefer opaque tokens and server-side lookups.
For production work, default to read-only unless mutation is explicitly requested or confirmed.

## Code Changes

Add comments only for non-obvious intent, constraints, or tradeoffs. Do not leave breadcrumb comments when code is moved or removed.
Keep files below 500 lines when practical. Existing files may grow to 1000 lines, but prefer extracting helpers or splitting modules before that.

## Git And Publishing

When asked to commit, inspect the current status, preserve unrelated work, stage intentionally, commit with an appropriate message, and verify the final status.
When asked to commit and push after a fix, check whether the fix is already committed before creating another commit.
When asked not to open a PR, stop after commit and push.
If GitHub CLI auth fails or lacks scopes, run `gh auth status` and try `gh auth refresh -h github.com` before treating GitHub access as blocked.

## Infrastructure

For Terraform/import work, do not run `apply` unless explicitly requested. Report whether the plan changes real infrastructure or only state/outputs.
