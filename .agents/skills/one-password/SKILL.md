---
name: one-password
description: "Use for local development or agent work that needs 1Password secrets, API keys, credentials, or environment variables. Prefer 1Password Environments with interactive op run for project runtime secrets, resolve project environment IDs from repo-local git config, use the service account only for exact reads from the Agent Runtime vault, and keep interactive op commands inside one persistent tmux session."
---

# 1Password Local Secrets

## Defaults

- Prefer 1Password Environments for local dev and agent runtime secrets.
- Run Environment-backed commands with interactive `op run --environment "$OP_ENVIRONMENT_ID" -- <command>`.
- Resolve `OP_ENVIRONMENT_ID` from repo-local Git config: `git config --local --get op.environment-id`.
- If no environment ID is configured, stop and ask the user for the project 1Password Environment ID.
- Do not fall back to plaintext `.env` files, broad shell environment dumps, or guessed vault/account state.
- Never print secret values. Verify only presence, shape, account, item title, field label, or output length.
- Use the 1Password service account only for the `Agent Runtime` vault. Do not expect it to access project Environments.
- For Environment-backed commands, unset `OP_SERVICE_ACCOUNT_TOKEN`; otherwise `op` may use service-account auth and fail to read Environments.

## Project Environment ID

For each repo, expect:

```bash
git config --local op.environment-id xxxxxxxxxxxxxxxxxxxxxxxxxx
```

Before a command needs secrets:

```bash
OP_ENVIRONMENT_ID="$(git config --local --get op.environment-id 2>/dev/null || true)"
if [ -z "$OP_ENVIRONMENT_ID" ]; then
  echo "Missing repo-local git config: op.environment-id" >&2
  exit 1
fi
env -u OP_SERVICE_ACCOUNT_TOKEN op run --environment "$OP_ENVIRONMENT_ID" -- <command>
```

If the user provides an environment ID, set it with:

```bash
git config --local op.environment-id <environment-id>
```

Do not use `git config --worktree` unless the user explicitly asks.

## Environment Commands

- Use `op run --environment "$OP_ENVIRONMENT_ID" -- ...` for tests, dev servers, scripts, build steps, SDK calls, and other project commands that need runtime secrets.
- Because the service account only has access to the `Agent Runtime` vault, any command using `--environment "$OP_ENVIRONMENT_ID"` must use interactive 1Password CLI auth.
- Prefix Environment-backed commands with `env -u OP_SERVICE_ACCOUNT_TOKEN` so service-account auth cannot override interactive auth.
- Run Environment-backed `op run` commands inside the persistent tmux session when they require auth, unlock, or retry handling.
- Treat an already-set `OP_ENVIRONMENT_ID` as a fallback only when not in a Git repo or when repo-local config is unavailable.
- Do not read arbitrary existing environment variables to discover secrets.
- Do not run `env`, `set`, `export -p`, or broad secret regex dumps.
- Query exact secret names only.
- If `op run` masks non-secret structured output and breaks parsing, rerun with `--no-masking` only when the command output is known not to contain secrets or PII.

## Service Account

Use a service account only for non-interactive exact reads from the `Agent Runtime` vault.

Rules:

- Scope service-account commands to `--vault "Agent Runtime"`.
- Do not use the service account for 1Password Environments.
- Do not enumerate vaults or items with the service account.
- If an expected item or field is unavailable, stop and ask instead of probing.
- Export service-account tokens only for the single command that needs them.

## Vault Reads

Use vault item reads only for secrets that are not project runtime environment variables, such as SSH keys, certificates, login items, recovery codes, or one-off exact fields.

Rules:

- Require exact vault/item/field intent from the user or repo docs.
- Do not enumerate vaults or items to browse for secrets.
- Prefer `op read` or exact `op item get` field reads.
- For service-account reads, always pass `--vault "Agent Runtime"`.
- Redact values in all output.

## Tmux For Interactive `op`

Interactive `op` commands must run inside one persistent named tmux session for the whole secret task. This keeps desktop-app authorization, retries, and CLI auth state in one shell.

Use tmux for:

- `op signin`
- `op whoami`
- `op account list`
- `op run --environment "$OP_ENVIRONMENT_ID" -- <command>`
- `op item get`, `op item create`, `op item edit`
- retrying a failed 1Password command after unlock or quoting fixes

Do not create a second tmux session just to retry. Send corrected commands to the existing session.

Pattern:

```bash
SOCKET_DIR="${CODEX_TMUX_SOCKET_DIR:-${TMPDIR:-/tmp}/codex-tmux-sockets}"
mkdir -p "$SOCKET_DIR"
SOCKET="$SOCKET_DIR/codex-op.sock"
SESSION="op-work"
tmux -S "$SOCKET" has-session -t "$SESSION" 2>/dev/null || tmux -S "$SOCKET" new -d -s "$SESSION" -n shell
PANE="$(tmux -S "$SOCKET" list-panes -t "$SESSION" -F '#{session_name}:#{window_index}.#{pane_index}' | head -n 1)"
tmux -S "$SOCKET" send-keys -t "$PANE" -- "env -u OP_SERVICE_ACCOUNT_TOKEN op whoami" Enter
tmux -S "$SOCKET" capture-pane -p -J -t "$PANE" -S -120
```

## Failure Handling

- If `op run` fails because the environment ID is missing, ask for the ID.
- If `op` says the account is not signed in, use the tmux session for `op signin`, then retry in the same session.
- If the 1Password app is locked or waiting for approval, tell the user to unlock/approve and keep the tmux session alive.
- If a command needs a secret and `OP_ENVIRONMENT_ID` is unavailable, do not run the command without secret injection unless the user explicitly approves a no-secret run.
