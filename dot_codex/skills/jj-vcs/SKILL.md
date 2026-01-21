---
name: jj-vcs
description: Jujutsu (jj) VCS guidance and workflows. Use when a user asks about jj commands, revsets, bookmarks, operation log/undo, Git compatibility/colocation, or migrating from Git to Jujutsu.
---

# jj-vcs

Provide practical guidance for Jujutsu (jj) workflows. Keep answers action-first and command-oriented.

## Quick start

- Identify repo type: Git-backed (most common) vs native.
- For Git-backed repos, prefer `jj git clone` or `jj git init`.
- Use `jj st`, `jj log`, and `jj diff` for day-to-day work.
- Remember: working copy is a commit; jj auto-snapshots on commands.

## Core mental model

- Treat the working copy as a real commit (`@`).
- Use revsets for selecting commits precisely.
- Use bookmarks instead of Git branches; there is no "current" bookmark.
- Use operation log for safety: `jj op log`, `jj undo`, `jj op restore`.

## Common workflows

### Start new work

- `jj new` to create a new commit on top of `@` or a target revset.
- `jj describe` to set the commit message.
- `jj bookmark create <name>` to name the work.

### Adjust history

- `jj squash` or `jj amend` to fold changes.
- `jj split` to break up a commit.
- `jj rebase` to move commits.
- `jj abandon <revset>` to drop commits.

### Sync with Git remotes

- `jj git fetch` to bring remote bookmarks.
- `jj git push --bookmark <name>` to publish.
- If needed, `jj git import` and `jj git export` for non-colocated repos.

## Revsets

- Use `@` for the working-copy commit.
- Use `x-` for parents, `x+` for children, `x::` for descendants.

See `references/revsets.md` for details.

## Bookmarks

- Bookmarks are named pointers; they move when commits are rewritten.
- Track remote bookmarks explicitly when needed.

See `references/bookmarks.md` for details.

## Git compatibility and colocation

- In colocated workspaces, jj and git share the same working copy.
- Mixing commands is allowed, but prefer jj for mutations.

See `references/git-compat.md` for details.

## Operation log and recovery

- Use `jj op log` to inspect repo history.
- Use `jj undo` for last operation.
- Use `jj op revert` or `jj op restore` for older operations.

See `references/op-log.md` for details.

## When unsure

- Run `jj help <command>` or `jj <command> -h`.
- Use `jj log -r <revset>` to verify selection before rewrites.
