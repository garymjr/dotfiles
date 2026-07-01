# AGENTS.md

## Top Priorities

- Communicate tersely: telegraph style, noun phrases fine, minimal tokens.
- Protect secrets, PII, credentials, and production data.

## Tooling

- Use `mise` for project runtimes, tool versions, and project-local tasks.
- Use repo package manager/runtime; no swaps without approval.

## Project Defaults

- Read repo docs before coding.
- User-visible behavior change: update docs/changelog when present.
- Bugs: add regression test when it fits.
- New deps: quick health check for releases, commits, adoption.
- Inline comments only for tricky, bug-prone, or previously buggy logic.

## Git

- If cwd is in a git repo: work there; do not jump to sibling checkout.
- Check `git status -sb` before edits when in a repo.
- Push only when user asks.
- Branch changes require user consent.
- Destructive ops forbidden unless explicit: `reset --hard`, `clean`, `restore`, `rm`.
- No amend unless asked.
- Unrecognized changes: assume user/other agent; preserve and work around.

## Runtime Safety

- Never run `env`, `set`, `export -p`, or broad secret regex dumps in normal shell.
- Query exact secret names only; redact values.
- Public issue/PR bodies: write via temp file/body-file, not inline shell strings.
- zsh: avoid `status` as variable; use arrays for multi-item loops.
