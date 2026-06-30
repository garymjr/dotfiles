# AGENTS.md

## Top Priorities

- Work style: telegraph; noun-phrases ok; drop grammar; min tokens.
- Protect secrets, PII, credentials, and production data.

## Operating Mode

- Make reasonable local choices about naming, file placement, helper extraction, test shape, and small nearby papercuts when the repo already shows a pattern.
- Run read-only inspection, read-only Git commands, project-local validation, and explicit user-requested read-only external probes without a separate approval gate. Verify identity/scope first for production, auth, infra, or data services, and keep output metadata-only when sensitive data could be present.
- Choose the smallest safe implementation that satisfies the request; do not stop at proposals, placeholders, stubs, mock-only paths, or TODO-only code.
- Ask only before decisions that materially affect product behavior, security posture, production data, infrastructure, dependencies, public APIs, or Git history.

## Validation

- If a formatter, linter, typecheck, build, or focused test fails because of the current change, fix it and rerun the relevant check.
- Update directly-caused tests, fixtures, snapshots, lockfiles, generated code, docs, or examples when needed to verify the change; report the command used.
- If a failure appears unrelated, stop broadening and report the exact error plus why it looks pre-existing.

## Safety Boundaries

- Never run broad environment dumps such as `env`, `set`, or `export -p`; query exact variable names and redact values.
- For auth, PII, credentials, and production data, avoid exposing raw values in prompts, logs, persisted records, or public output; prefer opaque tokens and server-side lookups.
- For production work, default to read-only. If the user asks for a read-only lookup, query, inventory, or diagnostic, do it after identity/scope verification without asking for command approval; gate only mutations, destructive actions, or reads likely to expose secrets, PII, credentials, or raw production records.
- Do not add dependencies without explicit approval; before proposing one, check whether the standard library or an existing dependency is enough.
- Destructive git, infrastructure, production data, or user-data operations require an explicit request. Do not amend commits, force-push, or rewrite published history without exact approval.

## Code Quality

- Use the repo's existing package manager, runtime, style, and helper APIs; do not swap tooling without approval.
- Keep files reasonably small; prefer helpers or modules before files become hard to scan.
- Add comments only for non-obvious intent, constraints, or tradeoffs; do not leave breadcrumb comments when code moves.

## Workspace

- Use `mise` for project runtimes and tool versions.
- If local cache, scratch, or build metadata paths are blocked, retry once with a scoped `/private/tmp/...` path and clean up what you created.
- If already inside a git repo, work in that checkout instead of jumping to a sibling clone unless asked.
- For AWS auth, prefer official `aws-core:*` skills. For SSO profiles, refresh expired sessions directly with `aws sso login --no-browser --use-device-code --profile <profile>`, then verify identity before the real AWS command.
