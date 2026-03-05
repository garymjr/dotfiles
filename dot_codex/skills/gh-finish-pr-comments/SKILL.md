---
name: gh-finish-pr-comments
description: Commit and push local fixes for the open GitHub PR on the current branch, then reply to and resolve addressed review threads. Use when PR feedback has already been implemented locally and Codex should finish the review cycle by validating the touched surface, creating a conventional commit, pushing the branch, posting thread replies, and resolving only the threads that are actually addressed.
---

# GH Finish PR Comments

## Overview

Finish the post-review workflow for the open PR on the current branch. Verify branch and PR context, validate the changed surface, commit and push the fixes when needed, then reply to and resolve the addressed review threads with concise, factual updates.

## Workflow

1. Verify prerequisites.
- Run `gh auth status`. If it fails, stop and tell the user to authenticate with `gh auth login`.
- Confirm the current branch has an open PR with `gh pr view`.
- Inspect local branch state with `git status --short`, `git diff --stat`, and `git log --oneline origin/HEAD..HEAD` or an equivalent base-aware comparison.

2. Inspect unresolved review threads.
- Run `python3 "$CODEX_HOME/skills/gh-finish-pr-comments/scripts/list_review_threads.py" --format json`.
- Read the unresolved thread list before drafting any replies.
- Use the thread path, line, outdated flag, and comment bodies to decide which threads are actually addressed by the current changes.
- Do not resolve threads that are still open questions, require product decisions, or are not covered by the current branch.

3. Validate the changed surface.
- Run targeted checks that match the code touched by the fixes.
- Prefer repo-native tests or linters over ad hoc reasoning.
- If validation fails, fix the issue before committing or replying.

4. Commit and push the fixes.
- If there are uncommitted changes, stage only the intended files and create a conventional commit message.
- Push the current branch to `origin`.
- If the tree is already clean, verify whether the branch is already ahead of `origin`. Push if needed.
- Never create an empty commit just to satisfy the workflow.

5. Draft thread replies from the actual changes.
- Keep replies short and concrete.
- State what changed and, when useful, mention the relevant file or behavior.
- Avoid generic replies like "fixed" or "done".
- If a thread is outdated but the concern is still addressed by the final code, say so plainly before resolving it.

6. Reply and resolve only the addressed threads.
- Prepare a JSON plan and pass it to `python3 "$CODEX_HOME/skills/gh-finish-pr-comments/scripts/reply_and_resolve_review_threads.py" --input <file>`.
- Use this shape:

```json
{
  "threads": [
    {
      "thread_id": "PRRT_xxx",
      "body": "Updated the validation to reject zero-length windows in the request parser.",
      "resolve": true
    }
  ]
}
```

- Use `--dry-run` first if there is any uncertainty about the selected thread IDs or messages.
- Leave unresolved threads out of the plan instead of sending weak replies.

7. Report the outcome.
- Summarize the commit hash, push target, validation run, and which threads were resolved.
- Call out any threads intentionally left unresolved and why.

## Script Usage

### `scripts/list_review_threads.py`

Use this script from `$CODEX_HOME/skills/gh-finish-pr-comments/scripts` to fetch review-thread context for the PR associated with the current branch.

Examples:

```bash
python3 "$CODEX_HOME/skills/gh-finish-pr-comments/scripts/list_review_threads.py" --format json
python3 "$CODEX_HOME/skills/gh-finish-pr-comments/scripts/list_review_threads.py" --all --format text
```

Default behavior:
- Shows unresolved review threads only.
- Includes PR metadata, file locations, outdated flags, and thread comments.

### `scripts/reply_and_resolve_review_threads.py`

Use this script from `$CODEX_HOME/skills/gh-finish-pr-comments/scripts` to post replies and resolve selected review threads.

Examples:

```bash
python3 "$CODEX_HOME/skills/gh-finish-pr-comments/scripts/reply_and_resolve_review_threads.py" --input plan.json
python3 "$CODEX_HOME/skills/gh-finish-pr-comments/scripts/reply_and_resolve_review_threads.py" --input plan.json --dry-run
cat plan.json | python3 "$CODEX_HOME/skills/gh-finish-pr-comments/scripts/reply_and_resolve_review_threads.py"
```

Rules:
- Each listed thread may include a reply body, a resolve flag, or both.
- Prefer including both a reply and `resolve: true` for addressed threads.
- The script does not decide what is addressed. Codex must make that decision from the diff and thread context.

## Guardrails

- Do not commit unrelated local changes.
- Do not resolve every unresolved thread by default.
- Do not reply before the relevant code is committed or at least confirmed in the local diff.
- Do not invent validation. If checks were not run, say so.
