---
name: opentofu
description: Work safely with OpenTofu/Terraform infrastructure code. Use when Codex needs to inspect, create, refactor, validate, plan, import, or review `.tf` roots/modules, especially stateful cloud infrastructure changes, remote state wiring, multi-environment root layouts, or cautious production-adjacent OpenTofu workflows.
---

# OpenTofu

## Overview

Use this skill for infrastructure-as-code work where state, remote backends, provider credentials, and blast radius matter. Prefer narrow inspection, scoped edits, and root-specific validation over broad repo-wide commands.

## Workflow

1. Locate the smallest affected root or module before editing.
   - Treat each directory containing `backend.tf`, `providers.tf`, and `versions.tf` as a likely independent root.
   - Inspect `remote_state.tf`, `outputs.tf`, module calls, README files, and backend state keys to understand dependency contracts.
   - Use `rg` for resource addresses, output names, provider aliases, backend keys, and environment-specific naming.

2. Confirm execution context before any stateful command.
   - Use `mise` when the repo defines runtimes or tool versions.
   - Check the exact root, backend, workspace assumptions, provider region, and cloud account/profile.
   - For AWS-backed roots, prefer `aws sts get-caller-identity --profile <profile>` before plan/apply work.
   - Never expose credentials, full environment dumps, secrets, PII, or production data.

3. Edit conservatively.
   - Preserve local root style: file names, locals maps, `for_each` patterns, provider constraints, tags, lifecycle rules, and output naming.
   - Do not put every resource into one large `main.tf`; when a root has multiple concerns, split resources into clear purpose-named files that match the repo's existing style.
   - Do not add dependencies, providers, modules, or public interfaces unless the task requires them.
   - Treat outputs and remote-state references as public contracts between roots; before renaming, removing, or moving one, find downstream consumers and plan the migration.
   - For imported or externally managed resources, identify ownership boundaries before changing desired arguments.
   - Keep lifecycle ignores only where they intentionally preserve external ownership; do not use them to hide an unintended drift or rollback.

4. Validate with the narrowest command that proves the change.
   - Start with formatting and validation for touched roots: `tofu fmt`, `tofu validate`.
   - Before `tofu init`, `tofu validate`, or `tofu plan` in Codex, set scoped temp paths such as `TF_DATA_DIR` and `TF_PLUGIN_CACHE_DIR` under `/private/tmp` when the root does not already provide safe local paths. Clean up only the temp directories you created.
   - Run `tofu init -reconfigure -input=false` when backend/provider metadata is stale or state/plan commands require initialization.
   - For stateful behavior, use `tofu plan -detailed-exitcode -input=false -no-color` in each affected root. A passing validate is not proof that OpenTofu will keep live infrastructure unchanged.
   - For requested review or validation, scoped `tofu init`, `tofu validate`, and `tofu plan` are acceptable without separate confirmation when they are read-only, use the intended root/profile/backend, and avoid exposing secrets or production data.
   - Treat exit code `0` as no diff, `2` as a non-empty plan to inspect and summarize, and `1` as an error to diagnose.
   - When a plan runs, tell the user what it would change: action counts, resource addresses, replacements/destroys, important argument changes, and output changes when visible.
   - Do not run `tofu apply`, `destroy`, state mutation, import, taint, or moved-state operations unless explicitly requested or confirmed for that exact target.

5. Report evidence.
   - Name the exact roots changed and commands run.
   - Summarize relevant plan outcomes, including whether the plan was empty or exactly which resources and outputs would change.
   - Call out unverified roots, skipped commands, missing credentials, or unrelated failures.

## Structure Guidance

When asked to structure or reorganize infrastructure, prefer many small independently planned roots over one large root when the repo already follows that pattern. Prefer app boundaries over generic layers: keep account-level/shared foundations separate from environment roots, put account-scoped apps under account app roots when they are not environment-specific, group runtime infrastructure by application ownership and blast radius, and wire dependencies through explicit remote-state outputs.

Read `references/infrastructure-layout.md` when creating or reorganizing roots, modeling environment/account separation, or checking whether a layout matches the user's preferred style.

## Common Commands

Run from the specific root unless the repo documents a wrapper:

```bash
tofu fmt
tofu init -reconfigure -input=false
tofu validate
tofu plan -detailed-exitcode -input=false -no-color
```

Use `tofu plan -target=...` only as an investigation aid or when the repo already uses targeted plans for that workflow; do not treat a targeted plan as complete proof for unrelated resources.

## Review Checklist

- Does the change affect the intended root only?
- Are backend keys, provider regions, account IDs, and environment names consistent?
- Are remote-state output names stable and consumed by the right downstream roots?
- Is root code organized into focused files rather than one oversized `main.tf`?
- Are imported resources protected from accidental replacement or rollback?
- Are lifecycle rules intentional and documented by surrounding code or plan evidence?
- Did validation include a real plan when live state behavior matters?
