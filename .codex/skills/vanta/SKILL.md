---
name: vanta
description: Work Vanta compliance, security, audit-evidence, test, and failing-entity requests with Vanta as the first source of truth. Use when the user asks about Vanta controls, tests, issues, failing assets, remediation prompts, audit evidence, closure, AWS/security findings shown in Vanta, or any Vanta-related follow-through.
---

# Vanta

## Overview

Route Vanta requests through the Vanta MCP before using secondary sources. Treat Vanta as authoritative for test metadata, issue state, remediation text, failing entities, closure requirements, and audit-evidence context.

## Workflow

1. Start with tool discovery for Vanta MCP tools.
   - Use `tool_search` for `vanta` unless Vanta MCP tools are already visible.
   - If no Vanta MCP tool is available, say that clearly, then continue with the best read-only fallback if useful.
2. Pull the Vanta-side context first:
   - Control or test name/id.
   - Current pass/fail or issue state.
   - Remediation prompt or policy requirement.
   - Failing entities and opaque Vanta entity ids.
   - Closure requirements, allowed reasons, and needed evidence/comment.
3. Preserve a read-only default:
   - Do not close Vanta issues, upload evidence, change Vanta scope, patch hosts, mutate cloud resources, or change production/user data unless the user explicitly asks or approves the exact action.
   - Use read-only AWS/GitHub/repo inspection only after Vanta metadata identifies what needs verification.
4. Reconcile secondary systems narrowly:
   - Use AWS, GitHub, repo, Sentry, or other tools only for the specific entities/tests surfaced by Vanta.
   - Avoid broad inventories unless Vanta metadata is insufficient and the user’s request requires asset identification.
5. Summarize with evidence:
   - State the Vanta test/control, current status, failing entities, likely owner/system, and safest next action.
   - Distinguish Vanta sync lag from live resource state when remediation appears complete outside Vanta.

## Safety Rules

- Protect secrets, PII, credentials, audit evidence, and production data. Prefer identifiers, account ids, regions, resource names, versions, severities, and summarized status over raw evidence or sensitive values.
- For production, security posture, compliance scope, cloud resources, auth, or user data, inspect first and ask before mutation unless the user already gave exact approval.
- Do not perform “checkbox” remediation that conflicts with the system architecture. Explain the mismatch and propose the smallest defensible fix or scope change.
- Before closing a Vanta issue, retrieve current Vanta state, closure reason options, and evidence/comment requirements; then get explicit approval for the closure text and reason.

## Common Patterns

### Failing Entities

When Vanta returns opaque entities, use Vanta metadata first, then make the narrowest second-hop lookup needed to map them to concrete resources. For AWS Inspector findings, this may require matching Vanta entity ids or package/CVE rows to Inspector findings before naming EC2 instances.

### Remediation

Prefer evidence-backed remediation plans:

- Vanta requirement.
- Current live state.
- Proposed change surface.
- Risk and rollback notes when mutation is requested.
- Verification command or readback.

### Follow-Up Tracking

If the user is not ready to remediate, preserve the Vanta test, failing entities, owner/system guess, and next safe action in the requested tracker or output artifact. Do not create worktrees, issues, or threads unless asked.
