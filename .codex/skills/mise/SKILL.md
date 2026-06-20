---
name: mise
description: Work with mise project tooling, runtime management, and task automation. Use when Codex needs to inspect, run, create, refactor, or debug mise configuration such as mise.toml, .mise.toml, .mise/config.toml, .tool-versions, .mise/tasks/*, task aliases, runtime installs, mise trust, or project-local commands run through mise.
---

# Mise

Use mise as the project-local entrypoint for tools, tasks, and runtime versions when a repo provides mise configuration.

## First Pass

1. Inspect the repo's mise surface before changing behavior:
   - `mise.toml`, `.mise.toml`, `.config/mise/config.toml`, `.mise/config.toml`
   - `.tool-versions`
   - `.mise/tasks/`
   - docs that mention `mise`, `just`, `make`, `npm scripts`, or setup commands
2. Prefer `mise run <task>` or `mise <task>` for declared project workflows.
3. Prefer `mise exec -- <command>` for ad hoc commands that should use the project's configured tools.
4. Run narrow validation first: `mise tasks`, `mise tasks validate`, `mise run <task>`, or the smallest relevant task.

## Trust

- Run `mise trust` in a repo only when the repo is already trusted by context: the user owns it, it is the active working checkout, and inspection has not surfaced suspicious config.
- Inspect mise config before trusting unfamiliar or freshly cloned repos, especially if it defines shell tasks, hooks, plugins, env files, or remote task includes.
- Do not run `mise trust` for untrusted third-party repos or production-adjacent infrastructure repos merely to make a command work. Explain what needs trust and ask before proceeding.
- If `mise` refuses to run because config is untrusted, report that exact condition unless the repo clearly meets the trusted-repo rule above.
- In Codex, `mise trust` can write user-level trust state outside the workspace. If the repo meets the trusted-repo rule and trust is required to continue, run the exact `mise trust` command with sandbox escalation instead of repeatedly retrying normal task commands.

## Tasks

- Keep tiny commands inline in mise config when they are single-purpose and readable.
- Put large shell-based tasks in executable files under `.mise/tasks/*`.
- Prefer one task file per substantial workflow. Use names that match the invoked task, such as `.mise/tasks/build`, `.mise/tasks/test`, or `.mise/tasks/deploy-dev`.
- Start shell task files with a shebang and strict mode when appropriate:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- Resolve paths from the task file location or project root explicitly. Avoid assuming the caller's current directory unless the existing tasks do.
- Keep task files focused on orchestration. Move reusable application logic into the project's normal source tree when it belongs there.
- For tasks with many flags or environment requirements, prefer a small documented argument parser over long inline shell snippets in TOML.
- Validate task syntax with the nearest relevant checks, commonly `mise tasks validate`, `bash -n .mise/tasks/<task>`, and a focused dry run or normal run.

## Config Changes

- Preserve the repo's existing mise config style: table layout, task naming, env conventions, aliases, and comments.
- Do not add new plugins, runtimes, or external dependencies without explicit user approval.
- When adding runtime versions, prefer exact versions already implied by lockfiles, engines fields, CI, Dockerfiles, or existing docs.
- Keep secrets out of mise config. Use env var names or documented secret-manager lookups, not raw values.
- Treat production deploy or infrastructure tasks as read-only unless the user explicitly asks for mutation.
- If a repo is migrating from `just`, `make`, package scripts, or ad hoc scripts, add mise wrappers narrowly and leave the old entrypoints intact unless the user requested removal.

## Running Commands

- Prefer `mise run <task>` over invoking internal task scripts directly, because mise supplies the intended environment.
- Use `mise run -- <task> ...` or the repo's existing argument pattern when forwarding task arguments.
- If a mise command succeeds but prints sandbox/cache warnings for `~/Library/Caches/mise` or shell prompt integrations, treat those warnings as non-blocking unless they affect the requested command's output or exit status.
- When running a child CLI through `mise exec --`, apply that CLI's sandbox-safe defaults first, such as `GOCACHE=/private/tmp/...` for Go or SwiftPM scratch paths for Swift.
- If a runtime or tool is missing, prefer `mise install` only after confirming the config is trusted and the install is project-local in intent. Report downloads or install failures clearly.
- Avoid broad commands such as `mise run all` until narrower checks have passed or the repo documents that command as the standard validation path.
- If mise behavior is surprising, inspect with targeted commands such as `mise current`, `mise ls`, `mise tasks`, `mise config`, or `mise doctor`, while avoiding output that may expose secrets.

## Review Checklist

- Ensure new or changed tasks are discoverable through `mise tasks`.
- Ensure large shell tasks live under `.mise/tasks/*`, not as dense TOML strings.
- Ensure task files are executable if the repo's existing mise tasks require that.
- Ensure validation commands ran through mise when project tooling depends on mise-managed runtimes.
- Ensure final summaries mention the task files changed and the exact mise commands used for validation.
