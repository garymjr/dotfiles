---
name: aws-cli
description: Use for AWS CLI work involving profiles, SSO credentials, STS identity checks, read-only investigation, or confirmed AWS changes.
---

# AWS CLI

## Authentication

When AWS credentials are needed, first check the active identity for the intended profile:

```bash
aws sts get-caller-identity --profile <profile>
```

If credentials are expired or unavailable, use AWS SSO device-code login:

```bash
aws sso login --profile <profile> --use-device-code
```

Do not try to open a browser automatically.

When device-code login starts, show the user the login URL and code clearly:

```text
AWS login required.
URL: <verification_url>
Code: <device_code>
```

Pause until the user approves the login from their phone. After approval, continue the original AWS task.

Prefer AWS SSO over long-lived access keys. Do not create, store, or request permanent AWS access keys unless the user explicitly asks.

## Profile And Region

Use an explicit `--profile <profile>` on AWS CLI commands unless the user has explicitly told you to rely on the ambient profile for that task.

If the profile is unclear, inspect available profile names without exposing credentials:

```bash
aws configure list-profiles
```

If the region is required and not obvious from the task, check the profile's configured region:

```bash
aws configure get region --profile <profile>
```

If no region is configured, ask for the intended region or infer it only from clear repo-local deployment config. Avoid broad environment dumps.

Before reporting account-specific results or performing any confirmed mutation, include the resolved AWS account ID, user/role ARN, profile, and region in the working notes or user-facing summary when useful.

## Safety

Default to read-only for AWS investigation and production work unless mutation is explicitly requested or confirmed.

Never run destructive AWS commands without confirmation, especially against prod accounts. This includes deleting resources, modifying IAM, changing networking, changing databases, or updating production infrastructure.

Before any AWS mutation, state the exact command, target account/profile/region, and expected effect. For production or destructive changes, wait for explicit confirmation after stating those details.

Prefer narrow resource-specific queries over broad inventory commands. Use `--query` and `--output json` when it reduces sensitive or noisy output.

For auth, PII, credentials, or production data work, keep sensitive data out of prompts, logs, persisted records, and public output.
