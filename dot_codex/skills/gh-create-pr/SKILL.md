---
name: gh-create-pr
description: Create a GitHub pull request from the current branch using gh CLI and git context checks. Use when asked to open a PR, draft PR title/body from local changes, verify branch readiness on origin, and return a final PR URL with explicit changed-file coverage.
---

# GitHub PR Creator

## Overview

Create a complete, accurate PR from the current branch with disciplined context gathering, file-by-file coverage, and deterministic output formatting.
Use `gh` CLI commands for GitHub interactions and `git` for local branch/diff checks.

## Required Workflow

1. Determine repo and branch context.
- Identify current branch, base branch, commit range, and changed files.
- Use `gh` plus `git` commands to build this context.

2. Ensure remote head branch readiness before creating a PR.
- Verify current branch exists on `origin`.
- If missing, run `git push -u origin <current-branch>`.
- Confirm there are commits in `<base>..HEAD`. If none, report that state and stop.

3. Build the PR title and body.
- Include relevant context from `$ARGUMENTS` when provided.
- Ensure the summary addresses all changes:
- Problem or context.
- What changed, grouped logically.
- Validation performed (tests, lint, manual checks).
- Risks or rollout notes.
- Include explicit file coverage so every changed file is mentioned at least once.

4. Create the PR.
- Use `gh pr create` with the prepared title and body.

5. Handle specific `gh pr create` failures once, then retry.
- If errors include `Head sha can't be blank`, `No commits between ...`, or `Head ref must be a branch`, treat as a remote head-branch readiness issue.
- Push or fix branch state, then retry `gh pr create` exactly one time.

## PR Body Format

Use this exact section structure:

- `## Summary`
- `## Changes`
- `## File Coverage`
- `## Validation`
- `## Risks`

In `## File Coverage`, map each changed file to a short note describing what changed in that file.

## Output Format

Return exactly:

1) `PR:` `<url>`
2) `Title:` `<final title>`
3) `Coverage:` `<N>/<N> changed files summarized`
4) `Notes:` concise caveats or `none`

If any `gh` command fails, include:
- Exact command run.
- Exact error output.

Keep the response compact and complete.
