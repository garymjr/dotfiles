---
description: Remove AI code slop
subtask: true
---

# Remove AI code slop

Target selection: Use `$ARGUMENTS` to determine scope.
- If `$ARGUMENTS` is a commit hash, run against that commit.
- If `$ARGUMENTS` is a branch name, run against that branch.
- If `$ARGUMENTS` is blank, operate on unpushed changes for the current branch.

Remove all AI-generated slop introduced relative to the chosen target.

This includes:
- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Casts to any to get around type issues
- Any other style that is inconsistent with the file

At the end, report only a 1-3 sentence summary of what you changed.
Do not commit changes until they are reviewed.

