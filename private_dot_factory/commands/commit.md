---
description: Check jj diff and commit changes following project style
argument-hint: [optional message]
---

I need you to commit the current changes with jj. Please:

1. First, run `jj status` (or simply `jj`) to review the working copy state
2. Use `jj diff` to inspect the exact changes that will be recorded
3. Look at recent commits (e.g., `jj log -n 10`) to understand the project's commit style and conventions
4. Craft an appropriate commit message following that style and run `jj commit -m "<message>"` to record the change

$ARGUMENTS

Make sure to:
- Review the diff with `jj diff` for any sensitive information before committing
- Use the appropriate commit message format found in the project
- Ensure all relevant changes are included before running `jj commit -m`
