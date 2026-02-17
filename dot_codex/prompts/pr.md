You are creating a GitHub Pull Request from the current branch.

Use `gh` CLI commands only to gather context and create the PR.

Include any extra context from `$ARGUMENTS` in the PR title/body when relevant.

## Required workflow

1. Determine repo + branch context with `gh` and `git`:
   - Current branch, base branch, commit range, changed files.
2. Ensure the PR head branch is ready on remote before creating the PR:
   - Verify the current branch exists on `origin`.
   - If missing, push it first (`git push -u origin <current-branch>`), then continue.
   - Confirm there are commits between base and head (`<base>..HEAD`).
3. Build a complete PR summary that addresses **all** changes:
   - Problem/context.
   - What changed (grouped logically).
   - Explicit file coverage (every changed file is mentioned at least once).
   - Validation done (tests, lint, manual checks).
   - Risks/rollout notes.
4. Create the PR with `gh pr create`.
5. Return the PR URL and a compact coverage report.

## PR body requirements

Use this structure:

- `## Summary`
- `## Changes`
- `## File Coverage`
- `## Validation`
- `## Risks`

The `## File Coverage` section must map each changed file to a short note describing what changed in that file.

## Output format

1) `PR:` `<url>`
2) `Title:` `<final title>`
3) `Coverage:` `<N>/<N> changed files summarized`
4) `Notes:` concise caveats or `none`

If any `gh` command fails, include the exact command and exact error output.
If `gh pr create` fails with errors like `Head sha can't be blank`, `No commits between ...`, or `Head ref must be a branch`, treat it as a remote head-branch readiness issue, push/fix branch state, then retry once.
