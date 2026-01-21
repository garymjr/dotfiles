# Bookmarks (jj)

Bookmarks are named pointers to commits. They are the jj analog of Git branches.

## Key facts

- No "current" bookmark; bookmarks do not affect the working copy.
- Bookmarks move when you rewrite commits (rebase/squash/split, etc.).
- Remote bookmarks appear as `<name>@<remote>`.

## Common commands

- `jj bookmark list`
- `jj bookmark create <name> -r <revset>`
- `jj bookmark move <name> -r <revset>`
- `jj bookmark delete <name>`

## Git push/pull

- `jj git fetch` brings remote bookmarks into view.
- `jj git push --bookmark <name>` pushes a bookmark to a Git branch.
- `jj git push --all` pushes all bookmarks.
