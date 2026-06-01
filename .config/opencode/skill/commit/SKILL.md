---
name: commit
description: Commit local git changes safely and intentionally. Use when Codex is asked to create a git commit, commit current changes, stage and commit work, or prepare a clean local commit without pushing or opening a pull request.
---

# Commit Changes

## Overview

Use this skill only for the local commit portion of a publish workflow: inspect scope, choose or keep the branch, stage intended changes, run relevant checks, commit, and report the result.

Do not push, open a pull request, or require GitHub CLI authentication unless the user asks for those steps separately.

## Workflow

1. Confirm intended scope.
   - Run `git status -sb` and inspect the diff before staging.
   - If the working tree contains unrelated changes, do not default to `git add -A`. Ask which files belong in the commit.
2. Determine the branch strategy.
   - If on `main`, `master`, or another default branch and the user expects feature work, create `codex/{description}`.
   - Otherwise stay on the current branch.
3. Stage only the intended changes.
   - Prefer explicit file paths when the worktree is mixed.
   - Use `git add -A` only when the user has confirmed the whole worktree belongs in scope.
4. Run the most relevant checks available if they have not already been run.
   - If checks fail due to missing dependencies or tools, install what is needed and rerun once when reasonable.
   - If checks cannot be run, keep the exact blocker for the final summary.
5. Commit tersely with the confirmed description.
   - Use a concise subject line matching the change.
   - Preserve required commit-message trailers from user, developer, or repo instructions.
6. Verify and summarize.
   - Run `git status -sb`.
   - Report branch name, commit hash or subject, validation performed, and any remaining uncommitted changes.

## Write Safety

- Never stage unrelated user changes silently.
- Never commit without inspecting the status and diff.
- Never rewrite history, amend, reset, or discard work unless the user explicitly asks.
- If the repository is not a git checkout, stop and explain the blocker.
