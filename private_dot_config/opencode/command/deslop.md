---
description: Remove AI code slop
subtask: true
---

# Remove AI code slop

---

Input: $ARGUMENTS

---

## Determining What to Deslop

Based on the input provided, determine which type of deslop to perform:

1. **No arguments (default)**: Deslop all uncommitted changes

   - Run: `git diff` for unstaged changes
   - Run: `git diff --cached` for staged changes

2. **Commit hash** (40-char SHA or short hash): Deslop that specific commit

   - Run: `git show $ARGUMENTS`

3. **Branch name**: Compare current branch to the specified branch

   - Run: `git diff $ARGUMENTS...HEAD`

4. **PR URL or number** (contains "github.com" or "pull" or looks like a PR number): Deslop the pull request
   - Run: `gh pr view $ARGUMENTS` to get PR context
   - Run: `gh pr diff $ARGUMENTS` to get the diff

Use best judgement when processing input.

Remove all AI-generated slop introduced relative to the chosen target.

This includes:
- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Casts to any to get around type issues
- Any other style that is inconsistent with the file

At the end, report only a 1-3 sentence summary of what you changed.
Do not commit changes until they are reviewed.

