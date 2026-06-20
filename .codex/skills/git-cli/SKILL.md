---
name: git-cli
description: Use for Git CLI work in Codex, including status, diff, branch, commit, push, fetch, rebase, worktree metadata, remote configuration, and avoiding known sandbox failures when Git writes .git config or shared worktree admin state.
---

# Git CLI

## Overview

Run Git commands with the right safety boundary: read-only commands stay sandboxed, while known local metadata writes in shared worktrees are handled deliberately instead of misdiagnosed as Git failures.

## First Pass

1. Inspect current state with read-only commands first: `git status --short`, `git branch --show-current`, `git remote -v`, `git worktree list`, or focused `git diff`.
2. Stay in the current checkout unless the user asks for another clone/worktree.
3. Preserve user changes. Do not reset, checkout away, clean, amend, force-push, or rewrite history without explicit approval for that exact action.

## Known Sandbox-Sensitive Git Commands

These Git operations may write outside the apparent worktree when `.git` points to a shared admin directory:

- `git remote add` or commands that update `.git/config`
- `git rebase`, `git rebase --continue`, and commands that create `.git/worktrees/.../rebase-merge`
- worktree create/remove/repair operations
- commands that write refs, lock files, or repository metadata outside the writable root

If the user requested one of these bounded local Git operations and read-only inspection shows it targets the current repo/branch, request or use sandbox escalation up front for that exact command when previous context or `.git` layout shows shared metadata outside the sandbox.

For `git rebase --continue`, prefer:

```bash
GIT_EDITOR=true git rebase --continue
```

This avoids editor hangs in Codex.

## Non-Negotiable Safety

- Do not run destructive Git commands unless explicitly requested.
- Do not broaden an escalated Git command beyond the exact repo-local operation needed.
- Do not use broad `git` prefix approvals.
- Before committing, refresh `git status --short` and review the staged diff.
- Before pushing, verify the branch and remote target.

## Reporting

If escalation was needed, name the metadata path or `.git` layout that required it. If a Git failure was unrelated to sandboxing, report the exact Git error instead.
