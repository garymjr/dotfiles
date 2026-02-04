---
name: gh-ready-ff-merge
description: Check GitHub PRs labeled "ready to merge" in the current repo, confirm both source and target branches are up to date with the repo remote, then fast-forward merge the PR head into the PR base branch and push the base branch. Use for label-driven, fast-forward-only merges that must halt if a non-FF merge is required.
---

# Gh Ready Ff Merge

## Overview

Scan the current repo for open PRs labeled "ready to merge" and fast-forward merge each PR head into its base branch using the repo's `origin` remote. Stop immediately if any merge cannot be fast-forwarded.

## Workflow

1. Ensure `gh` auth works and the repo has an `origin` remote.
2. List open PRs with the "ready to merge" label in the current repo.
3. For each PR, require head and base repositories to match the current repo and skip forks.
4. Fetch `origin/<base>` and `origin/<head>`.
5. Checkout `<base>` and run `git pull --ff-only origin <base>`.
6. Run `git merge --ff-only origin/<head>`.
7. Run `git push origin <base>`.
8. Exit non-zero on any failure to keep a hard stop.

## Script

Use the bundled script for repeatability and safety checks:

```bash
python3 scripts/ready_ff_merge.py
```

For a no-mutation preview:

```bash
python3 scripts/ready_ff_merge.py --dry-run
```

## Notes

- Require a clean working tree before running.
- Do not attempt non-fast-forward merges.

## Resources

### scripts/
- `ready_ff_merge.py`: Automate PR discovery and fast-forward merge flow.
