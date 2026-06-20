---
name: aws-cdk
description: Work safely with AWS CDK and CloudFormation apps, stacks, constructs, synth, diff, imports, deployments, bootstrap roles, and migrations.
---

# AWS CDK

## Overview

Use this skill for AWS CDK and CloudFormation work where stack boundaries, deployment safety, logical IDs, generated templates, imports, and production blast radius matter. Prefer repo-grounded inspection, local synth validation, and explicit approval before any account or stack mutation.

## Workflow

1. Locate the CDK app and deployment surface before editing.
   - Inspect `cdk.json`, `package.json`, `bin/`, `lib/`, `stacks/`, `constructs/`, `cdk.context.json`, README files, CI workflows, and existing synth outputs when present.
   - Identify the exact app, account, region, stage, stack name, bootstrap assumptions, and package manager.
   - Use the repo's runtime manager and scripts when available, such as `mise run cdk-check`, `npm run cdk:synth`, `pnpm cdk synth`, or the project equivalent.

2. Classify the request before acting.
   - For review or layout questions, inspect source and synthesized templates; answer from observed stack/resource boundaries instead of generic rules.
   - For code changes, keep edits scoped to the requested app, construct, stack, or migration.
   - For imports, deploys, bootstraps, or raw CloudFormation changes, treat the work as mutation-gated unless the user has approved the exact account, region, stack, command class, and intended effect.

3. Model with constructs and deploy with stacks.
   - Use constructs for reusable or cohesive logical units; use stacks to describe deployment boundaries.
   - Keep resources in the same stack when they change, roll back, and are owned together.
   - Split stacks when lifecycle, account, region, owner, statefulness, termination protection, import boundary, blast radius, or deployment cadence differs.
   - Do not create a stack just because a resource uses a different AWS service.
   - Do not merge stacks just because one has only one or two resources if it owns a meaningful lifecycle or security boundary.

4. Preserve stable stateful resources.
   - Treat logical IDs and construct paths for stateful resources as compatibility contracts.
   - Before moving or renaming constructs, check synthesized logical IDs and downstream references.
   - Prefer explicit removal policies for production stateful resources such as buckets, repositories, databases, user pools, certificates, KMS keys, and log archives.
   - Use imports, `Retain`, and staged migrations when taking over existing resources.

5. Keep synthesis deterministic and side-effect free.
   - Avoid live AWS lookups during normal synth unless the repo already commits and manages `cdk.context.json`.
   - Do not modify cloud resources during synthesis.
   - Prefer checked-in account/stage configuration, explicit props, static `from*` imports, or generated input files refreshed by an intentional command.
   - Never embed secrets, credentials, private keys, tokens, passwords, PII, or production data in CDK code, templates, logs, or summaries.

6. Validate locally first.
   - Run the narrowest local validation that proves the change: typecheck, unit tests, synth, and template inspection.
   - Inspect synthesized templates when boundary, resource count, logical ID, IAM, policy, removal policy, or import behavior matters.
   - For live `cdk diff` preflights, verify scoped identity first with `aws sts get-caller-identity --profile <profile> --region <region>`, then prefer CDK's global profile form: `npx cdk --profile <profile> diff <stack> --region <region> --no-change-set`.
   - If AWS CLI calls work but CDK says credentials are missing, rerun with `--verbose` before changing AWS/profile assumptions. Look for sandbox or filesystem failures such as `EPERM` writing `~/.cdk/cache/accounts_partitions.json`; CDK may need local cache write access even for read-only diff.
   - Summarize stack names, resource counts, meaningful resource types, logical ID changes, output/export changes, and security-sensitive IAM/policy changes.

## Stack Naming

Use lowercase stack names in this form for new stacks unless the existing deployment surface requires a compatibility exception:

```text
[project/app]-[module/service]-[environment]-[region]
```

Examples: `gateway-console-prod-us-east-1`, `nvsep-network-staging-us-east-2`.

## Stack Boundary Heuristics

Prefer a single cohesive stack for:

- One application or capability whose resources deploy and roll back together.
- Static site or service infrastructure that shares ownership, routing, identity, and policies.
- Small supporting resources that only exist for the parent capability.

Prefer separate stacks for:

- Stateful resources that need termination protection or independent rollback.
- Cross-account or cross-region resources.
- Security, CI, audit, identity, or compliance controls with distinct ownership.
- Imported existing resources whose CloudFormation ownership must be staged carefully.
- Shared platform resources consumed by multiple apps, such as registries, OAM sinks, hosted zones, or baseline controls.
- Resources with materially different deployment cadence or blast radius.

Treat one-resource stacks as acceptable only when the lifecycle boundary is real. Otherwise, keep the resource inside the nearest app or capability stack.

## CloudFormation Import And Migration

- Start with read-only inventory and current-state comparison.
- Check whether each resource type supports CloudFormation import.
- Match the CDK model to the live resource before import; avoid "fixing" drift during the first ownership transfer.
- Prepare resource mappings and review the import change set before execution.
- Import in slices when dependencies make a single import risky.
- After import, verify stack status, stack resources, drift detection, and the old IaC state cleanup plan.
- Do not remove old Terraform/OpenTofu/Pulumi state or config until CloudFormation ownership is verified and the user has approved the cleanup.

## Mutation Safety

Do not run these without explicit approval for the exact target and intended effect:

- `cdk bootstrap`
- `cdk deploy`
- `cdk import`
- `cdk destroy`
- `aws cloudformation create-change-set`, `execute-change-set`, `delete-stack`, `update-stack`, `create-stack`, or import/update/delete equivalents
- Any command that changes AWS resources, CloudFormation stacks, or IaC state

Read-only commands such as `cdk synth`, template inspection, `aws cloudformation describe-*`, `list-*`, `get-*`, and `aws sts get-caller-identity` are acceptable when scoped to the requested account and region.

## Review Checklist

- Do new stack names follow lowercase `[project/app]-[module/service]-[environment]-[region]`, unless preserving an existing deployment surface?
- Are stacks aligned to deployment lifecycle and ownership rather than service type?
- Are cohesive app resources grouped together where safe?
- Are stateful resources protected from accidental deletion or logical ID churn?
- Are account and region boundaries explicit?
- Are IAM policies least-privilege enough for the task and free of secret values?
- Are cross-stack references, exports, and static imports intentional?
- Is synth deterministic and free of live mutation or untracked lookups?
- Did validation include the project-local synth/check command and synthesized-template inspection when relevant?
- If imports or deploys are involved, was the change set reviewed before execution?
