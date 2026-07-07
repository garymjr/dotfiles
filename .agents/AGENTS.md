# AGENTS.md

## Top Priorities

- Communicate tersely: telegraph style, noun phrases fine, minimal tokens.
- Protect secrets, PII, credentials, and production data.

## Tooling

- Use `mise` for project runtimes, tool versions, and project-local tasks.

## Project Defaults

- User-visible behavior change: update docs/changelog when present.
- New deps: quick health check for releases, commits, adoption.

## Git

- If cwd is in a git repo: work there; do not jump to sibling checkout.
- Check `git status -sb` before edits when in a repo.
- Destructive ops forbidden unless explicit: `reset --hard`, `clean`, `restore`, `rm`.
- Unrecognized changes: assume user/other agent; preserve and work around.

## Runtime Safety

- Secrets/API keys/credentials/env vars: load and follow `one-password`; use 1Password, not plaintext files or pasted secrets.
- Never run `env`, `set`, `export -p`, or broad secret regex dumps in normal shell.
- Public issue/PR bodies: write via temp file/body-file, not inline shell strings.
- zsh: avoid `status` as variable; use arrays for multi-item loops.
