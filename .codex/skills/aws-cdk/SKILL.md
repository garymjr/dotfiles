---
name: aws-cdk
description: Work safely with AWS CDK and CloudFormation apps, stacks, constructs, synth, diff, imports, deployments, bootstrap roles, and migrations.
---

# AWS CDK

## Overview

Use this skill for AWS CDK and CloudFormation work where stack boundaries, deployment safety, logical IDs, generated templates, imports, and production blast radius matter. Prefer repo-grounded inspection, local synth validation, and explicit approval before deploy/update/delete style account or stack mutation. Treat AWS best practices as design inputs, not automatic rules: preserve existing ownership, lifecycle, and migration constraints when they conflict with a generic recommendation. Correct CloudFormation imports are generally safe ownership transfers and can proceed after self-review when the import is clean, expected, and within the user's requested migration scope.

## Workflow

1. Locate the CDK app and deployment surface before editing.
   - Inspect `cdk.json`, `package.json`, `bin/`, `lib/`, `stacks/`, `constructs/`, `cdk.context.json`, README files, CI workflows, and existing synth outputs when present.
   - Identify the exact app, account, region, stage, stack name, bootstrap assumptions, and package manager.
   - Use the repo's runtime manager and scripts when available, such as `mise run cdk-check`, `npm run cdk:synth`, `pnpm cdk synth`, or the project equivalent.

2. Classify the request before acting.
   - For review or layout questions, inspect source and synthesized templates; answer from observed stack/resource boundaries instead of generic rules.
   - For code changes, keep edits scoped to the requested app, construct, stack, or migration.
   - For deploys, destroys, non-import updates, or raw CloudFormation changes that create, update, replace, or delete resources, treat the work as mutation-gated unless the user has approved the exact account, region, stack, command class, and intended effect.
   - For imports, self-review the exact stack, account, region, mapping, template, live physical IDs, and change set. If the result is import-only and exactly expected, separate user approval is not required when the user has requested the migration/import work. Pause for approval or correction if the plan includes replacement, physical delete, unexpected create/update, missing `Retain`, unmapped resources, live metadata mismatch, unsupported import types, ownership-boundary confusion, or app-owned/release-coupled resources.
   - `cdk bootstrap` is implicitly approved when read-only checks have confirmed the exact account/region has not been bootstrapped yet.
   - If the code was generated from, migrated from, or compared against Terraform/OpenTofu/Pulumi, identify whether existing stack/resource groups are temporary import slices, live CloudFormation ownership boundaries, or durable target boundaries before recommending changes.

3. Model with constructs and deploy with stacks.
   - Use constructs for reusable or cohesive logical units; use stacks to describe deployment boundaries.
   - Keep resources in the same stack when they change, roll back, and are owned together.
   - Split stacks when lifecycle, account, region, owner, statefulness, termination protection, import boundary, blast radius, or deployment cadence differs.
   - Do not create a stack just because a resource uses a different AWS service.
   - Do not merge stacks just because one has only one or two resources if it owns a meaningful lifecycle or security boundary.
   - Do not mirror Terraform/OpenTofu state files, modules, moved blocks, import lists, or resource slices into one-for-one CDK stacks unless the user explicitly asks for a temporary import plan.
   - For new CDK architecture, start from application capability and CloudFormation lifecycle boundaries. Use the old IaC layout only as inventory and migration evidence.

4. Preserve stable stateful resources.
   - Treat logical IDs and construct paths for stateful resources as compatibility contracts.
   - Before moving or renaming constructs, check synthesized logical IDs and downstream references.
   - Prefer explicit removal policies for production stateful resources such as buckets, repositories, databases, user pools, certificates, KMS keys, and log archives.
   - Use imports, `Retain`, and staged migrations when taking over existing resources.
   - If resources are already CloudFormation-owned, do not casually collapse or reshuffle stacks. Treat consolidation as a retained-detach plus later import/adoption migration that needs explicit approval and a rollback plan.

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

## CDK Design Defaults

Use these defaults when creating or refactoring CDK stacks unless the existing deployment surface requires compatibility:

- Keep the CDK app close to the application or platform component that owns the lifecycle.
- Prefer constructs for logical units such as network, ingress, identity, data, observability, registry, and compute platform.
- Prefer stacks for deployment units: account/region boundaries, stateful protection, security ownership, rollback blast radius, import/adoption phase, and release cadence.
- Keep as many resources together as deployment requirements allow; split only for a real boundary.
- Model every stage in code with explicit stage/account/region configuration.
- Avoid deployment-time parameters and conditions for ordinary stage decisions; make the decision in CDK code.
- Prefer generated physical names for new resources. Use explicit names only for imports, externally referenced resources, compatibility, or stable public contracts.
- Let CDK grants and L2/L3 constructs handle routine IAM/security-group wiring when they fit the ownership model, but do not force them when imported resources, existing roles, permission boundaries, or security-team ownership require explicit modeling.
- Define removal policies and log retention intentionally for stateful and production resources.
- Commit or intentionally manage `cdk.context.json` when lookups are used.

Do not call something "best practice" unless it fits the actual ownership, migration, and deployment model in the repo. For migrations, a temporary import stack can be correct for adoption mechanics and still be the wrong long-term architecture.

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

## Migration From Terraform/OpenTofu/Pulumi

- Use the old IaC as inventory: physical names, dependencies, resource policies, tags, drift clues, and state ownership.
- Do not infer CDK stack boundaries from old state keys, root modules, files, or import batches.
- Separate temporary import mechanics from target architecture in code comments, docs, and final summaries.
- For unmanaged resources, import in safe slices when dependencies require it, then consolidate only if the target lifecycle supports it.
- For resources already owned by CloudFormation, preserve existing stack identities and logical IDs unless the user approved a retained detach/import migration.
- When moving ownership between repos, decide app-owned versus platform-owned first. Runtime assets, release selection, ECS service deployments, task definitions, Lambda code, and other release-coupled resources usually belong with the app. Shared registries, networks, baseline security, edge, identity, data stores, and account controls often belong with platform or infra repos, depending on ownership.
- Document any temporary stacks as temporary. Make the desired steady-state stack list explicit so future agents do not preserve import slices as architecture.

## CloudFormation Import And Migration

- Start with read-only inventory and current-state comparison.
- Check whether each resource type supports CloudFormation import.
- Match the CDK model to the live resource before import; avoid "fixing" drift during the first ownership transfer.
- Prepare resource mappings and review the import change set before execution.
- Treat correct import-only change sets as generally safe: if the reviewed change set imports only the intended existing resources and shows no creates, updates, replacements, deletes, policy broadening, or physical-name surprises, the agent may execute it without another approval when the user already asked for imports or migration.
- Stop and ask before import execution if any resource is unmapped, unsupported, already CloudFormation-owned by a different stack, missing `Retain` where stateful, mismatched against live metadata, coupled to app release mechanics, or outside the agreed ownership boundary.
- Import in slices when dependencies make a single import risky.
- After import, verify stack status, stack resources, drift detection, and the old IaC state cleanup plan.
- Do not remove old Terraform/OpenTofu/Pulumi state or config until CloudFormation ownership is verified and the user has approved the cleanup.

## Mutation Safety

Do not run these without explicit approval for the exact target and intended effect:

- `cdk deploy`
- `cdk destroy`
- `aws cloudformation create-change-set` or `execute-change-set` for create/update/delete/replacement changes
- `aws cloudformation delete-stack`, `update-stack`, `create-stack`, or non-import equivalents
- Any command that creates, updates, replaces, or deletes AWS resources, CloudFormation stacks, or IaC state outside a reviewed import-only ownership transfer

`cdk import` and raw CloudFormation import change sets may proceed without
separate approval when all of these are true: the user requested the
migration/import work; identity, account, region, stack, logical IDs, physical
IDs, and resource mappings have been verified; the template matches live
metadata; the change set is import-only and exactly expected; and stateful
resources have appropriate `Retain` protections. If any import review shows
replacement, physical delete, unexpected create/update, unsupported import
behavior, missing `Retain`, ownership-boundary mismatch, or live metadata drift,
pause and get explicit approval or fix the model before proceeding.

`cdk bootstrap` is implicitly approved when read-only checks have confirmed the
exact account and region have not been bootstrapped yet, such as no `CDKToolkit`
stack and no `/cdk-bootstrap/<qualifier>/version` SSM parameter. Scope the
command to that account and region and summarize the bootstrap resources it will
create. If a bootstrap stack or version parameter already exists, treat
bootstrap as mutation-gated and get explicit approval before updating it.

Read-only commands such as `cdk synth`, template inspection, `aws cloudformation describe-*`, `list-*`, `get-*`, and `aws sts get-caller-identity` are acceptable when scoped to the requested account and region.

## Review Checklist

- Do new stack names follow lowercase `[project/app]-[module/service]-[environment]-[region]`, unless preserving an existing deployment surface?
- Are stacks aligned to deployment lifecycle and ownership rather than service type?
- Are stack boundaries independent of Terraform/OpenTofu/Pulumi state slices unless this is an explicitly temporary import step?
- Are cohesive app resources grouped together where safe?
- Are stateful resources protected from accidental deletion or logical ID churn?
- Are already CloudFormation-owned resources preserved unless an approved retained-detach/import migration is in scope?
- Are account and region boundaries explicit?
- Are IAM policies least-privilege enough for the task and free of secret values?
- Are cross-stack references, exports, and static imports intentional?
- Is synth deterministic and free of live mutation or untracked lookups?
- Did validation include the project-local synth/check command and synthesized-template inspection when relevant?
- If imports are involved, was the mapping and import-only change set
  self-reviewed as clean and expected before execution?
- If deploys or non-import changes are involved, was the change set reviewed and
  explicitly approved before execution?
