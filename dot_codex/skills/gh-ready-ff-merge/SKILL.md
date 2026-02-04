---
name: gh-ready-ff-merge
description: Check GitHub PRs labeled "ready to merge" in the current repo, confirm both source and target branches are up to date with the repo remote, then fast-forward merge the PR head into the PR base branch and push the base branch. Use for label-driven, fast-forward-only merges that must halt if a non-FF merge is required.
---

# Gh Ready Ff Merge

## Overview

Scan the current repo for open PRs labeled "ready to merge" and fast-forward merge each PR head into its base branch using the repo's `origin` remote. Use a temporary git worktree per PR and remove it after each merge. Stop immediately if any merge cannot be fast-forwarded.

## Workflow

1. Ensure `gh` auth works and the repo has an `origin` remote.
2. List open PRs with the "ready to merge" label in the current repo:

```bash
gh pr list --state open --label "ready to merge" --json number,title,url,headRefName,baseRefName,headRepository,isCrossRepository
```

3. For each PR, require head and base repositories to match the current repo and skip forks.
4. Fetch `origin/<base>` and `origin/<head>`:

```bash
git fetch origin <base>
git fetch origin <head>
```

5. Create a temporary worktree at `origin/<base>`:

```bash
wt=$(mktemp -d -t gh-ready-ff-merge-XXXXXX)
git worktree add --detach "$wt" "origin/<base>"
```

6. Run a fast-forward merge inside the worktree:

```bash
git -C "$wt" merge --ff-only "origin/<head>"
```

7. Push the fast-forwarded `HEAD` back to the base branch:

```bash
git -C "$wt" push origin "HEAD:<base>"
```

8. Remove the temporary worktree:

```bash
git worktree remove --force "$wt"
```

9. Remove the label from the PR:

```bash
gh pr edit <number> --remove-label "ready to merge"
```

10. Exit non-zero on any failure to keep a hard stop.

## Notes

- Do not attempt non-fast-forward merges.
- Worktrees keep the main working directory untouched.

## Resources

None.
