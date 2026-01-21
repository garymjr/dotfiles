# Operation log and recovery

Jujutsu records repository operations and lets you undo or restore them.

## Commands

- `jj op log` to view operations.
- `jj undo` to undo the last operation.
- `jj op restore <op>` to restore repo state to a specific operation.
- `jj op revert <op>` to create a new operation that reverts an earlier one.
