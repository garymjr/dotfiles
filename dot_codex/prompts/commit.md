# Commit Cleanup and Atomic Commit Template

Review the repository's current uncommitted changes, clean up sloppy edits, and commit the results atomically.

## Instructions

1. Inspect all uncommitted changes.
   - Check staged, unstaged, and untracked files.
   - Read diffs before modifying anything.
2. Review for sloppy or accidental edits.
   - Remove debug prints, temporary comments, dead code, and obvious copy/paste mistakes.
   - Fix inconsistent formatting or naming in touched code.
   - Split unrelated changes when possible.
3. Clean up issues you find.
   - Make the smallest safe edits needed.
   - Keep behavior intentional and consistent with the codebase.
4. Re-check quality after cleanup.
   - Re-run relevant checks/tests for touched areas when available.
   - Confirm there are no outstanding issues in the current change set.
5. If and only if there are no outstanding issues, create atomic commits for all current uncommitted changes.
   - Group changes by concern/scope.
   - Use clear Conventional Commit messages (`fix:`, `feat:`, `chore:`, `test:`, `ci:`).
   - Ensure each commit is logically independent and reviewable.

## Output format

- `Review findings:` short list of issues found and what was cleaned.
- `Validation:` what was run/checked and result.
- `Commits created:` one line per commit with `<sha> <message>`.
- `Outstanding issues:` `none` or a concise blocker list.

If issues remain that prevent safe commits, do not commit. Report blockers clearly.
