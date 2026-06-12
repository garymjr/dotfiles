---
name: thread-maintenance
description: Use when Codex needs to inspect, summarize, or archive old Codex threads, including requests to clean up threads older than N days, archive stale conversations, or do routine thread maintenance. Defaults to archiving threads older than 7 days when no age threshold is specified.
---

# Thread Maintenance

## Overview

Maintain Codex thread hygiene by finding stale threads and archiving the ones that are safe to close. Prefer the Codex thread tools over filesystem inspection because the tools know the app's current thread metadata and archive state.

## Workflow

1. Resolve the age threshold.
   - Use the user's explicit value when they say "older than N days."
   - Default to `7` days when no threshold is provided.
   - Treat "older than N days" as strictly earlier than now minus N days.

2. Load the thread-management tools.
   - Use `tool_search` first for `list_threads` and `set_thread_archived`.
   - If the user asks to inspect or continue a specific thread, also load `read_thread`.

3. List candidate threads.
   - Request enough threads to cover the threshold window; page or repeat calls if the tool returns a cursor or limited page.
   - Prefer metadata fields such as `updated_at`, `created_at`, `archived`, `pinned`, `title`, `thread_id`, and worktree/current-thread indicators.
   - Use `updated_at` as the age signal when available; otherwise use `created_at` and mention the fallback in the final summary.

4. Filter conservatively.
   - Include only unarchived threads older than the threshold.
   - Skip the current thread, pinned threads, queued or running threads, and threads with unresolved tool activity when that state is visible.
   - If metadata is missing or ambiguous, skip the thread and report the uncertainty instead of guessing.

5. Archive the filtered set.
   - Call `set_thread_archived` for each eligible thread with archived state set to true.
   - Do not delete threads; this skill archives only.
   - If a tool call fails, continue with the remaining candidates when safe, then report the exact failure.

6. Summarize the result.
   - State the threshold used and the cutoff date/time.
   - Report counts for listed, eligible, archived, skipped, and failed threads.
   - Include concise identifiers or titles for archived threads unless the list is very long; for long lists, show a small sample and the total count.

## Safety

- Never archive the active conversation.
- Do not archive pinned threads unless the user explicitly asks for pinned threads to be included.
- Ask before archiving when the request is only exploratory, such as "show me old threads" or "what would be archived?"
- Preserve privacy: summarize titles and IDs only; do not quote sensitive thread content unless the user asks to inspect a specific thread.
