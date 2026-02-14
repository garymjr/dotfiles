---
name: secrets
description: Use this skill when the user asks to save, retrieve, list, rotate, or delete secrets in zigbot via the `secrets_store` tool.
---

# Secrets Skill

Use the `secrets_store` tool for all secret management in zigbot.

## When To Use

- User asks to save credentials, tokens, keys, or environment values.
- User asks to fetch a previously saved secret.
- User asks to list available secret names.
- User asks to delete or rotate a secret.

## Operations

- `set`: requires `key` and `value`, upserts secret.
- `get`: requires `key`, returns the raw stored value.
- `list`: optional `prefix`, returns matching key names only.
- `delete`: requires `key`, removes the secret if present.

## Behavior

- Storage backend is SQLite at `<config-dir>/secrets.sqlite3`.
- Keys are plain text names.
- Values are stored as plain text.
- `list` never returns values, only key names.

## Execution Rules

- Prefer `set` when user says create/update/save.
- Prefer `get` for read/access/reveal requests.
- Prefer `list` before guessing exact key names.
- Prefer `delete` for revoke/remove requests.
- Confirm required fields are present before tool execution.
