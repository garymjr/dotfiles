# Git compatibility and colocation

Jujutsu can use a Git repository as the backing store. This is the default for `jj git init` and `jj git clone`.

## Colocated repo behavior

- A colocated workspace shares a Git working copy and `.git` directory.
- Git sees a detached HEAD while jj tracks state separately.
- You can run Git commands, but prefer jj for history edits and rebases.

## Import/export

- `jj git import` pulls Git refs into jj.
- `jj git export` writes jj state back to Git refs.

Use import/export when not using colocation or when you need to sync after running Git commands directly.
