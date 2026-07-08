---
name: one-password
description: "Use when local development or agent work needs 1Password CLI (`op`) secrets, API keys, credentials, or storing/retrieving agent-owned secrets. The agent has full access to the `Agent Runtime` vault; use it for agent-managed secrets, but never dump secret values."
---

# 1Password CLI (`op`)

Use 1Password as the only approved plaintext-secret boundary. Read and write secrets through `op`; never ask the user to paste secrets into chat, files, logs, or shell history.

## Hard Rules

- Never print, echo, log, summarize, or diff secret values from 1Password.
- Never run broad secret dumps: `env`, `set`, `export -p`, `printenv`, broad regex scans, or full JSON item dumps that include values.
- Never store secrets in `.env`, source files, config files, command history, issue bodies, or PR text.
- Do not enumerate vaults/items to browse for interesting secrets. Use exact item/title/field intent from the user, repo docs, or task context.
- Prefer verifying by presence, item title, field label, username/account identifier, fingerprint, expiry, length, or last 4 chars only when safe.
- Redact all command output before user-visible responses.
- Use `--vault "Agent Runtime"` for agent-owned secret reads/writes unless the user explicitly names a different vault.

## Vault Scope

The agent has full read/write access to the `Agent Runtime` vault.

Use `Agent Runtime` for:

- API keys/tokens used by agents and local automation.
- Temporary credentials the user asks the agent to store.
- Recovery codes, certificates, SSH keys, or service credentials owned by agent workflows.
- Metadata needed to find credentials later, if non-sensitive.

Do not use `Agent Runtime` for project/user secrets if repo docs specify a different vault.

## Authentication Checks

Prefer narrow checks:

```bash
op --version
op whoami
```

If `op` is not signed in or the app is locked, ask the user to unlock/approve 1Password, then retry. Do not ask for master passwords or secret keys.

## Exact Reads

Use exact field reads. Avoid dumping whole items.

```bash
op read 'op://Agent Runtime/<item>/<field>'
op item get '<item>' --vault 'Agent Runtime' --fields label='<field>' --reveal
```

When a command needs a secret, inject it directly into that command without printing it:

```bash
TOKEN="$(op read 'op://Agent Runtime/<item>/<field>')" command-that-needs-token
```

If the command may log argv, prefer stdin, config file descriptors, or supported secret-reference mechanisms over command-line flags.

## Storing Secrets

Before creating or changing a secret, state the intended item/field/vault and get user approval unless the user explicitly asked for that exact write.

Create a login/password/API credential in `Agent Runtime`:

```bash
op item create --vault 'Agent Runtime' --category login \
  --title '<item title>' \
  username='<non-secret identifier>' \
  credential='<secret value>'
```

Edit an exact field:

```bash
op item edit '<item title>' --vault 'Agent Runtime' '<field>=<new secret value>'
```

Prefer passing secret values via stdin or a temporary file with restrictive permissions when supported. If shell interpolation is unavoidable, avoid exposing the command in logs/history and remove any temp file immediately.

## Safe Output Patterns

Allowed:

- "Found item `<title>` in `Agent Runtime`; field `<field>` present."
- "Token available; length 40; not displayed."
- "Updated `<item>` field `<field>` in `Agent Runtime`."

Forbidden:

- Secret values, full item JSON, one-time codes, private keys, recovery codes, session tokens.
- Screenshots or logs containing secret values.

## Failure Handling

- `op: command not found`: ask to install 1Password CLI (`op`) or approve installation.
- Not signed in / app locked: ask user to unlock/approve 1Password; retry after confirmation.
- Item/field not found: stop and ask for exact item/field. Do not probe broadly.
- Permission denied outside `Agent Runtime`: explain current scope and ask user to grant access or provide an approved vault/reference.
