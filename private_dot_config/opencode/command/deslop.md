---
description: Remove AI code slop
model: opencode/big-pickle
---

# Remove AI code slop

---

Input: $ARGUMENTS

---

## Determining What to Deslop

Always deslop the current uncommitted changes only.

- Run: `git diff` for unstaged changes
- Run: `git diff --cached` for staged changes

Remove all AI-generated slop introduced relative to the chosen target.

This includes:

- Extra comments that a human wouldn't add or is inconsistent with the rest of the file
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Casts to any to get around type issues
- Any other style that is inconsistent with the file

At the end, report only a 1-3 sentence summary of what you changed.
Do not commit changes until they are reviewed.
