---
name: vanta-mcp
description: Review Vanta compliance tests, controls, policies, evidence, vendors, and vulnerabilities through Vanta's hosted MCP endpoint. Use when Codex needs to retrieve or summarize Vanta data, report deadlines, or inspect available Vanta tools. This skill uses a local OAuth adapter and treats every mutation as opt-in.
---

# Vanta MCP

Use the bundled adapter; it connects directly to Vanta's hosted streamable-HTTP MCP server. OAuth state is stored as a concealed item in the 1Password `Agent Runtime` vault. Do not expose Vanta credentials to prompts, files, logs, or summaries.

## Authentication and discovery

Run the adapter from this skill directory. The first request requires interactive browser OAuth:

```sh
node scripts/vanta-mcp.mjs auth
node scripts/vanta-mcp.mjs list-tools
```

Run adapter commands with permission to reach the local 1Password service and Vanta. If a sandboxed command reports a 1Password, local-daemon, socket, network, or permission-access failure, retry that same command once with elevated sandbox permission and a concise justification. Do this before diagnosing missing or expired authentication. Do not escalate merely because a Vanta tool response is empty or malformed.

Use `VANTA_MCP_REGION=eu` or `VANTA_MCP_REGION=aus` before the command for a non-US Vanta tenant. Use `VANTA_MCP_URL` only for an explicitly supplied Vanta endpoint.

Always call `list-tools` before a workflow when the exact tool name or schema is unknown. Use the returned schemas exactly; do not infer endpoint names or fields.

## Read-only work

Call a discovered, read-only tool as follows:

```sh
node scripts/vanta-mcp.mjs call TOOL_NAME '{"field":"value"}'
```

Prefer narrow requests and return only the data needed for the user’s question. For deadline reviews, retrieve the relevant test records, filter to overdue and the next 30 calendar days, then report name, due date, owner/assignee, status, and a concrete next action. Do not modify records.

## Mutation safety

The adapter refuses tools not explicitly marked read-only. Do not use `--allow-write` unless the user has explicitly approved the specific Vanta change after seeing its intended effect. Never set a persistent environment variable that bypasses this check.

## Failures

If authentication is missing or expired, instruct the user to run `auth` interactively. First retry once with elevated sandbox permission when the error indicates the sandbox cannot reach 1Password or Vanta; do not confuse that with an authentication failure. If elevated access also fails, report the access failure without falling back to file-based token storage. If the server exposes no matching tool, report that fact rather than guessing or calling a similarly named mutation.
