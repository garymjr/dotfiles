---
name: review-greptile-comments
description: Fetch, analyze, fix, reply to, and resolve Greptile comments on GitHub pull requests, defaulting to the current branch's PR. Use for Greptile bot feedback, actionable findings, handled threads, and write-back unless the user opts out.
---

# Review Greptile Comments

Use the GitHub app from this plugin as the primary interface for PR metadata, diffs, files, comments, replies, and review writes. Use `gh api graphql` only when thread-level fields such as `reviewThreads`, `isResolved`, `isOutdated`, or `resolveReviewThread` are required and the GitHub app result is not sufficient.

## Workflow

1. Resolve the target PR.
   - If the user provides a PR URL, parse the repository full name and PR number.
   - If the user provides a repository and PR number, use those values directly.
   - If no PR is specified, default to the current branch's PR. Inspect local git context, then run `gh pr view --json number,url,headRefName,headRefOid,baseRefName` or use equivalent GitHub app context to resolve the PR.
   - If the current branch has no associated PR, say that clearly and ask for a PR URL, repository plus PR number, or a branch with an open PR.
   - Fetch PR metadata with the GitHub app `_get_pr_info`, then fetch the patch with `_fetch_pr_patch` or focused files with `_fetch_pr_file_patch`.
2. Fetch Greptile feedback.
   - Use the GitHub app `_fetch_pr_comments` first.
   - Identify Greptile-authored items by author login, display name, or body markers that clearly indicate Greptile. Treat uncertain attribution as uncertain and say so.
   - If resolution state matters, fetch review threads with GraphQL and include `id`, `isResolved`, `isOutdated`, `path`, `line`, `startLine`, `diffSide`, `isCollapsed`, `comments.author.login`, `comments.body`, `comments.url`, and `comments.databaseId`.
3. Analyze comments before editing.
   - Cluster comments by file, behavior, and root cause.
   - Separate valid actionable issues from false positives, obsolete comments, duplicates, style-only suggestions, and comments that require product judgment.
   - Inspect nearby code and tests before deciding that a Greptile comment is valid.
   - Present a short numbered list if the user asked to choose scope; otherwise continue when the request is to fix all actionable Greptile comments.
4. Implement focused fixes.
   - Keep changes traceable to the Greptile comments being addressed.
   - Prefer the repository's existing patterns and nearby tests.
   - Add regression coverage when the project shape makes that reasonable.
   - Do not broaden into unrelated cleanup.
5. Validate.
   - Run the narrowest formatter, typecheck, build, or test command that covers the changed code.
   - If a check fails because of the current change, fix it and rerun.
   - If a check fails for an unrelated reason, capture the exact failure and explain why it appears unrelated.
6. Reply and resolve handled Greptile conversations after changes are made.
   - Default to GitHub write-back. When the user asks to review, fix, address, or handle Greptile comments, treat that as approval to reply to and resolve the Greptile conversations that the resulting code changes directly address.
   - Skip GitHub write-back only when the user explicitly says not to reply, not to resolve, review-only, summarize-only, dry run, do not write to GitHub, or similar.
   - Use GitHub app write tools for replies or review comments when they are sufficient.
   - Leave a concise reply on each handled Greptile thread that starts with `@greptileai` and names the fix, the touched file or behavior, and the validation run when useful.
   - Use GraphQL `resolveReviewThread` only after verifying the exact Greptile thread id and only for comments actually addressed by a change or intentionally dismissed with a stated reason.
   - Do not resolve comments that were only analyzed, are still ambiguous, require product judgment, conflict with another comment, or were not covered by validation.
   - If write-back fails because of auth, API, or thread-id limitations, report the exact blocker and provide the `@greptileai` reply text and thread ids that still need action.

## GitHub App Tooling

- `_get_pr_info`: PR title, body, refs, head SHA, and state.
- `_fetch_pr_patch`: complete PR patch for analysis.
- `_fetch_pr_file_patch`: focused patch for a specific file.
- `_fetch_file`: current repository file content at a branch, tag, or commit.
- `_fetch_pr_comments`: combined PR conversation, review submissions, and inline review comments.
- `_reply_to_review_comment`: reply to an inline review thread.
- `_add_comment_to_issue`: add a top-level PR conversation comment.
- `_add_review_to_pr`: submit a review when the user explicitly asks.

## Safety

- Do not submit reviews, request reviewers, or post unrelated GitHub comments without explicit user approval for that write action.
- When the user asks to review, fix, address, or handle Greptile comments, replying to and resolving only the Greptile conversations directly addressed by the changes is in scope unless the user explicitly opts out.
- Always include `@greptileai` in replies to Greptile, including posted replies and fallback reply drafts.
- Do not expose secrets, private data, or large proprietary code excerpts in summaries or replies.
- Do not mark a Greptile comment resolved just because a code change was made; verify the fix maps to the specific thread.
- If Greptile is wrong, prefer a short explanation and optional reply draft over a code change that weakens the system.
- If comments conflict, pause and explain the tradeoff before editing.

## Final Response

Summarize the Greptile comments addressed, files changed, validation commands run, replies posted, conversations resolved, and any comments left unresolved. If GitHub write-back was skipped because the user opted out or a tool failed, say that explicitly.
