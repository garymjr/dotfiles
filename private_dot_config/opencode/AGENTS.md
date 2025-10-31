# Agent Guidelines for Jujutsu (jj) VCS

Best practices for agents using [Jujutsu (jj)](https://jj-vcs.github.io/jj/latest/) as the primary VCS. When repositories support jj (have a `.jj/` directory), prefer jj commands over git.

## Key Principles

1. **Always use jj when available** - Use jj commands exclusively for `.jj/` directories
2. **Embrace jj's model** - Use change IDs, bookmarks, and operations instead of git concepts
3. **Leverage superior features** - Operation log, change-based workflow, intuitive history manipulation

## Command Reference

| Task | jj Command |
|------|-----|
| Log | `jj log`, `jj log -p` |
| Status | `jj status` / `jj st` |
| Show | `jj show <rev>` |
| Diff | `jj diff` |
| Commit | `jj commit -m "msg"` / `jj new` |
| Amend | `jj describe` |
| Metadata | `jj metaedit` |
| Rebase | `jj rebase` |
| Manipulate | `jj squash`, `jj split`, `jj absorb`, `jj revert`, `jj abandon` |
| Bookmarks | `jj bookmark list/create/delete/rename/set` |
| Undo/Redo | `jj undo`, `jj redo` |
| History | `jj op log`, `jj op show <op-id>`, `jj op restore <op-id>` |

*Note: jj auto-tracks changes; no staging needed. Reference current commit with `@`.*

## Best Practices

- **Change IDs**: Use stable identifiers (`jj log -r <change-id>`) that survive rebasing
- **Descriptions**: Use descriptive messages (`jj describe -m "Fix: ..."`)
- **Organization**: Use `jj new` for logical separation, `jj squash` to combine
- **Operation Log**: Track state via `jj op log`, restore with `jj op restore <op-id>`
- **Bookmarks**: Track revisions (`jj bookmark create <name>`, `jj bookmark track main@origin`)
- **Manipulation**: Move changes between revisions (`jj squash -f <src> -t <dest>`, `jj absorb`)

## Git Fallback & Colocated Repos

**Non-jj repos**: Use `jj git fetch/push` for git interoperability or fall back to git commands.

**Colocated repos** (both `.jj/` and `.git/`): Both jj and git work on the same repository. Use `jj git export/import` to sync with git.
