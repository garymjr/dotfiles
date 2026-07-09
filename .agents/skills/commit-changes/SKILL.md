---
name: commit-changes
description: Commit local changes, push a branch, and open a draft GitHub PR. Use when the user asks to commit changes, create a branch if on the default branch, push, or create a draft PR.
---

# Commit Changes

Use this skill when the user wants local work committed, pushed, and opened as a draft GitHub pull request.

## Workflow

1. Inspect repository state.
   - Run `git status -sb` before making any git changes.
   - Verify the current directory is inside a git worktree with `git rev-parse --show-toplevel`.
   - Identify the current branch with `git branch --show-current`.
   - Identify the default branch with `git symbolic-ref refs/remotes/origin/HEAD --short`; strip the `origin/` prefix. If this fails, fall back to `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`.
2. Create a branch when currently on the default branch.
   - If the current branch equals the default branch, create a new branch before committing.
   - Prefer a short, descriptive branch name derived from the change, such as `agent/<topic>`.
   - If the change topic is unclear, ask the user for a branch name instead of guessing.
   - Use `git switch -c <branch>`.
3. Review changes before committing.
   - Run `git diff --stat` and inspect relevant diffs before staging.
   - Preserve unrelated user changes. If unrelated changes are present, stage only the files that belong to the requested work.
   - If ownership is ambiguous, ask before staging.
   - Do not commit secrets, credentials, generated noise, or local-only config unless explicitly requested.
4. Commit changes.
   - Stage intended files with `git add <paths>`.
   - Run `git diff --cached --stat` and inspect the staged diff.
   - If there are no staged changes, stop and tell the user there is nothing to commit.
   - Create a concise commit message that matches the repo style. Inspect `git log --oneline -10` when style is unclear.
   - Run `git commit -m "<message>"`.
5. Push the branch.
   - Confirm GitHub CLI auth with `gh auth status` before creating a PR.
   - Push with `git push -u origin <branch>`.
6. Create a draft PR.
   - Use `gh pr create --draft --fill` when the generated title and body are adequate.
   - If `--fill` would be unclear, provide explicit `--title` and use a temp body file for `--body-file`.
   - Return the PR URL from `gh pr create` to the user.

## Guardrails

- Never run destructive git commands such as `git reset --hard`, `git clean`, or `git checkout --` unless the user explicitly approves them.
- Never amend, squash, rebase, force-push, or resolve merge conflicts unless explicitly requested.
- Do not switch away from a non-default branch just to create a PR; commit and push the current branch unless the user asks otherwise.
- If the worktree has pre-existing unrelated changes, keep them out of the commit.
- If hooks fail, fix only issues related to the intended changes and create a new successful commit attempt; do not bypass hooks.
- If `gh` is not authenticated, ask the user to authenticate with `gh auth login` and stop before pushing or creating the PR.

## Output Expectations

Report:

- branch name
- commit hash and message
- draft PR URL
- checks or hooks that ran, including any failures
