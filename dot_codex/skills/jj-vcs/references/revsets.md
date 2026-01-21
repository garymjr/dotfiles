# Revsets (jj)

Use revsets to select commits. Many commands accept revsets; some expect exactly one commit and error if the selection is empty or multi-commit.

## Symbols

- `@` = working-copy commit in current workspace.
- `<name>@<remote>` = remote-tracking bookmark.
- Commit ID or change ID (full or unique prefix).

## Operators (core)

- `x-` parents of `x`.
- `x+` children of `x`.
- `x::` descendants of `x` (includes `x`).
- `::x` ancestors of `x` (includes `x`).
- `x::y` commits on ancestry path from `x` to `y`.
- `x..y` ancestors of `y` that are not ancestors of `x`.
- `::` all visible commits.
- `x & y`, `x | y`, `x ~ y` for set ops.

## Tips

- Use `jj log -r <revset>` to verify selection before rewriting.
- Use quotes to prevent a symbol from being parsed as an expression (example: `jj log -r '\"x-\"'`).
