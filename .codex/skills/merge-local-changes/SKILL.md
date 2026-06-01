---
name: merge-local-changes
description: Merge the current local branch into a requested target branch, or the repository default branch when no target is provided, with git safety checks. Use when Codex is asked to merge local branch changes, fast-forward a feature branch into another branch, rebase then merge if needed, or otherwise land the current branch locally without pushing or opening a pull request.
---

# Merge Local Changes

## Overview

Use this skill to land the currently checked-out branch into a target branch using local git only. If the user names a target branch, merge into that branch. If no target is provided, merge into the repository's default branch. Prefer a clean fast-forward merge. If the current branch cannot be fast-forward-merged to the target, rebase the current branch onto the target, then fast-forward the target to the rebased branch.

Do not push, open a pull request, delete branches, or rewrite remote history unless the user asks for those steps separately.

## Workflow

1. Inspect the repository state.
   - Run `git status -sb`.
   - Stop if the working tree has unstaged or staged changes unless the user explicitly wants those included and the merge/rebase can safely proceed.
   - Stop if not in a git repository.
2. Identify the current branch.
   - Run `git branch --show-current`.
   - Stop if detached HEAD unless the user gives a branch name to land.
3. Identify the target branch.
   - If the user named a branch to merge into, use that exact branch as `<target-branch>`.
   - If no branch was provided, identify the default branch by preferring `git symbolic-ref --short refs/remotes/origin/HEAD` and stripping `origin/`.
   - If no branch was provided and `origin/HEAD` is unavailable, check `git remote show origin` for `HEAD branch`.
   - If still unclear, fall back to `main`.
   - If the fallback branch does not exist locally, try `master`; otherwise stop and explain the blocker.
   - Stop if `<source-branch>` is the same as `<target-branch>`; report that there is no branch-to-branch merge to do.
4. Refresh target branch information when safe.
   - If an `origin` remote exists, run `git fetch origin`.
   - If network, auth, or sandbox restrictions block fetch, continue with local refs only and report that limitation.
5. Ensure the local target branch exists.
   - If it does not exist but `origin/<target-branch>` does, create it with `git switch -c <target-branch> --track origin/<target-branch>`.
   - Otherwise switch to the existing local target branch with `git switch <target-branch>`.
6. Try the clean fast-forward merge first.
   - Run `git merge --ff-only <source-branch>` while on the target branch.
   - If it succeeds, verify with `git status -sb` and summarize the source branch, target branch, and resulting HEAD.
7. If fast-forward merge fails, rebase the source branch onto the target.
   - Switch back with `git switch <source-branch>`.
   - Run `git rebase <target-branch>`.
   - If conflicts occur, stop with the exact conflicted files and do not continue the merge.
   - After a successful rebase, switch to the target branch and run `git merge --ff-only <source-branch>`.
8. Verify and report.
   - Run `git status -sb`.
   - Optionally run `git log --oneline --decorate -5` when useful to show the final branch position.
   - Report whether the landing path was direct fast-forward or rebase plus fast-forward.

## Safety Rules

- Never run a non-fast-forward merge for this workflow.
- Never run `git push`, `git branch -d`, `git reset`, or `git rebase --abort` unless the user explicitly asks or confirms after seeing the state.
- Preserve unrelated user changes. If the worktree is dirty or has untracked files that could be affected, stop and ask before proceeding.
- If rebase conflicts occur, leave the repository in its conflict state and give the user the exact next commands they can choose from.
- If a target branch was provided, do not silently substitute a different branch.
- If default branch detection is uncertain, say which fallback was used.
