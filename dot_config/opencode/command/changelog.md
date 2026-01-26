---
description: Generate changelog from PR
---

Process each commit in this pull request individually. For each commit, generate exactly one single-line changelog entry based on its commit message. Clean up grammar and capitalization if needed. Do not include prefixes like "fix:" or "feat:".
Classify each entry as either a Feature or a Bug Fix and organize the output under these two headings only.
If a commit is a "chore", include it only if it results in a user-visible feature or bug fix, and classify it accordingly. Otherwise, omit it entirely.
Do not merge commits, add extra sections, or include omitted commits in the output.

PR commits:
!`gh pr view $ARGUMENTS --json commits --jq '.commits[].messageHeadline'`
