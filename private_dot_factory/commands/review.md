---
description: Perform a code review using gh CLI, checking for code quality issues
argument-hint: <branch-or-pr>
---

Please perform a code review on `$ARGUMENTS` using the gh cli. Only look at new additions and the current diff.

Check for:
- unnecessary or duplicate code
- unnecessary comments or bloat
- overly complicated logic that can be done simpler
- unintuitive or inconsistent naming
- inconsistent coding patterns

Each review should contain:
1. Outline of the issue
2. Suggest how you would improve it
3. Present code suggestions as a diff
4. Include a conversational comment about the issue and the suggestion

Please don't:
- Submit any comments using the gh cli
- Edit any code
