---
description: Perform a code review on a PR using the gh cli
---

Perform a code review on $1 using the gh cli. Only look at new additions and the current diff.

Check for:

- unnecessary or duplicate code
- unnecessary comments or bloat
- overly complicated logic that can be done simpler
- unintuitive or inconsistent naming
- inconsistent coding patterns

Each review should follow this format for EVERY issue found:

1. **Issue**: Clear description of the problem
2. **Suggestion**: How to improve it
3. **Code Diff**: Isolated diff showing only the changes for this specific issue
4. **Explanation**: Message explaining why this change improves the code

IMPORTANT REQUIREMENTS:

- Each issue MUST have its own separate, isolated diff
- NEVER combine multiple issues in one diff
- Each diff should show only the minimal changes needed for that specific issue
- Review each issue individually - do not group related issues together

Please don't:

- Submit any comments using the gh cli
- Edit any code
- Combine multiple issues into a single diff
