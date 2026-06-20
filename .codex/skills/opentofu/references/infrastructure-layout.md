# Infrastructure Layout Reference

Use this reference when creating, reorganizing, or reviewing OpenTofu layout. The `nvsep` repository is the model for the preferred structure.

## Preferred Shape

Organize infrastructure as a product folder with independent roots:

```text
infrastructure/tofu/<product>/
├── account/
│   ├── audit/
│   ├── apps/
│   │   └── console/
│   ├── ci/
│   ├── dns/
│   ├── foundation/
│   ├── identity/
│   └── registry/
└── envs/
    ├── dev/
    │   ├── shared/
    │   │   ├── dns/
    │   │   ├── ingress/
    │   │   ├── network/
    │   │   ├── observability/
    │   │   └── security/
    │   └── apps/
    │       ├── api/
    │       ├── worker/
    │       └── web/
    ├── qa/
    └── prod/
```

Each leaf directory is a separately initialized and planned root. Prefer this over a single root with a broad environment switch when the infrastructure has distinct application ownership, blast radius, or release cadence. Use `account/apps/<app>` for account-scoped applications such as a control-plane console, and `envs/<env>/apps/<app>` for environment-scoped applications.

## Root File Pattern

Use these files when applicable:

- `versions.tf`: required OpenTofu/provider versions.
- `backend.tf`: remote backend config with a root-specific state key.
- `providers.tf`: provider region and aliases.
- `main.tf`: small root entrypoint, shared locals, or simple resources only; split substantial resource groups into purpose-named files such as `iam.tf`, `buckets.tf`, `dns.tf`, `cloudfront.tf`, or `alarms.tf` according to the root's domain.
- `remote_state.tf`: explicit upstream dependencies.
- `outputs.tf`: stable downstream contract.
- `imports.tf`: checked-in imports for resources adopted into management.
- `README.md`: root-specific notes only when useful.

Keep backend keys stable and descriptive, for example `<product>/account/apps/<app>.tfstate`, `<product>/envs/<env>/apps/<app>.tfstate`, or `<product>/account/<shared-boundary>.tfstate`.

## Dependency Direction

Prefer an app-boundary graph:

1. `account/*` creates shared account-level foundations such as registry, DNS, identity, audit, and CI roles.
2. `account/apps/<app>` roots own account-scoped app boundaries and consume account-level outputs.
3. `envs/<env>/shared/network` creates VPC/subnet/security-group primitives for the environment.
4. Other shared environment roots such as `shared/ingress`, `shared/security`, and `shared/observability` expose explicit outputs for application roots.
5. `envs/<env>/apps/<app>` roots own environment-scoped app boundaries and consume upstream outputs.

Wire roots with `data "terraform_remote_state"` and explicit outputs. Avoid hidden dependencies through naming conventions alone. When a root moves or splits, update both the producer's backend key and outputs and every consumer's remote-state reference in the same migration plan.

## Safety Patterns

- Run commands from each affected leaf root, not just from the product directory.
- Use `tofu init -reconfigure -input=false` when working with an S3 backend that may not be initialized locally.
- Use `tofu validate` for syntax/schema checks and `tofu plan -detailed-exitcode -input=false -no-color` for stateful proof.
- For imported resources, inspect both config and plan output. Removing a configured argument can still produce a planned drift such as `argument -> null`.
- Preserve `prevent_destroy` and intentional `ignore_changes` entries unless the task explicitly changes ownership.
- For deploy-owned ECS services, avoid putting task definition revisions under OpenTofu ownership; keep `task_definition` ignored when deployments own revisions and prove the plan is empty.

## Naming and Style

- Match the existing root's map/`for_each` style before introducing variables or modules.
- Keep root files focused by concern; avoid creating or extending a catch-all `main.tf` when named files would be easier to scan.
- Prefer explicit per-environment maps when the surrounding root uses them.
- Keep outputs as small contracts for downstream roots, and keep remote-state references pointed at stable backend keys.
- Keep account IDs, regions, and state bucket names consistent with backend/provider files.
- Do not move resources between roots without a planned state migration strategy and explicit approval.
