---
name: coderabbit
description: Find unresolved CodeRabbit comments on the active GitHub pull request for the current branch. Use when Codex needs to inspect CodeRabbit review feedback, summarize unresolved bot threads, or gather actionable CodeRabbit comments before making PR fixes.
---

# CodeRabbit

Find unresolved CodeRabbit review feedback for the current branch's active PR. Prefer the GitHub app connector for repository, PR, metadata, and flat comment context; use `gh api graphql` only when thread-level resolution state is required and the connector does not expose it.

## Workflow

1. Confirm local Git context.
   - Run `git rev-parse --show-toplevel`, `git branch --show-current`, and `git remote -v`.
   - If there is no branch or no GitHub remote, ask for the repository and PR number or URL.
2. Resolve the active PR.
   - Use the GitHub connector first when it can list or resolve PRs for the current repository and branch.
   - If the connector cannot resolve the branch PR, use `gh pr view --json number,url,headRefName,baseRefName,author` from the checkout.
   - If more than one PR matches, ask which PR to inspect.
3. Fetch review data with resolution state.
   - Use the GitHub connector for PR metadata, commits, files, and any available comment lists.
   - For unresolved thread accuracy, use GraphQL `reviewThreads` because flat comment APIs often omit `isResolved`.
   - Filter threads where `isResolved` is false and at least one comment author login matches CodeRabbit.
4. Recognize CodeRabbit authors conservatively.
   - Treat `coderabbitai` and `coderabbitai[bot]` as the canonical CodeRabbit GitHub App identities.
   - Treat `coderabbit` and `code-rabbit` only as legacy or fallback matches when surrounding context clearly identifies the author as CodeRabbit.
   - If a similar bot name appears, include it only when the login or display name clearly identifies CodeRabbit.
5. Report actionable unresolved comments.
   - Group by file path, then by thread.
   - Include PR URL, branch, file, line or original line when available, author login, a concise paraphrase, and whether the thread is outdated.
   - Preserve short exact quotes only when useful; avoid dumping long bot comments.
   - Separate actionable requests from praise, summaries, duplicates, and non-blocking notes.

## GraphQL Pattern

Use this shape when the connector lacks unresolved thread state. Page through `reviewThreads` until `pageInfo.hasNextPage` is false.

```graphql
query($owner: String!, $repo: String!, $number: Int!, $cursor: String) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      url
      headRefName
      reviewThreads(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          isResolved
          isOutdated
          path
          line
          originalLine
          comments(first: 50) {
            nodes {
              author { login }
              body
              createdAt
              url
            }
          }
        }
      }
    }
  }
}
```

Example command:

```bash
gh api graphql -f owner=OWNER -f repo=REPO -F number=PR_NUMBER -f query='QUERY_TEXT'
```

## Output

- Start with a count: total unresolved CodeRabbit threads and how many look actionable.
- List each unresolved actionable thread with enough location detail to find it.
- Include a short "Not counted" note for resolved, outdated-only, duplicate, or non-CodeRabbit threads when that explains a surprising count.
- If no unresolved CodeRabbit comments remain, say that clearly and mention whether thread resolution state came from GraphQL or only from connector-visible data.

## Safety

- Do not post replies, resolve threads, submit reviews, push commits, or change PR state unless the user explicitly asks.
- Do not expose secrets or private data from comments beyond what is necessary to identify the review item.
- If GitHub auth fails, inspect the exact error and ask the user to refresh authentication rather than guessing.
