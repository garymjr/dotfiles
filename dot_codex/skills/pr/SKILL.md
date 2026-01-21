---
name: pr
description: "Pull request workflows: view PRs, read comments, reply with fixes, and merge etiquette."
---

Use this skill when the user asks about PRs, reviewing PRs, or PR comment workflows.

## PR Workflow

- Use `gh pr view` and `gh pr diff` for PR context. No URLs.
- Active PR: `gh pr view --json number,title,url --jq '"PR #\\(.number): \\(.title)\\n\\(.url)"'`.
- PR comments: `gh pr view …` plus `gh api …/comments --paginate`.
- Replies: cite fix + file/line. Resolve threads only after fix lands.
- Always add title and body to PR. Avoid bullet lists.
- When merging a PR: thank the contributor in `CHANGELOG.md`.
