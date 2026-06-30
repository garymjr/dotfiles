---
name: thread
description: Manage Codex app threads and project-thread creation. Use when creating, forking, inspecting, continuing, handing off, pinning, archiving, renaming, or otherwise coordinating Codex threads, especially when the user asks to create a new thread in a project or repository and worktree behavior matters.
---

# Thread

## Overview

Use Codex app thread tools deliberately. Prefer a new up-to-date worktree thread for project/repo work unless the user explicitly asks for a local/current-checkout thread or says not to create a worktree.

## Tool Selection

- Search for the relevant thread tool first: `create_thread`, `fork_thread`, `list_threads`, `read_thread`, `send_message_to_thread`, `handoff_thread`, `set_thread_pinned`, `set_thread_archived`, or `set_thread_title`.
- Use app thread tools instead of raw text directives when a matching tool exists.
- Use `create_thread` only when the user explicitly asks to create a new thread. Created threads are user-owned and visible in the Codex sidebar.
- Use multi-agent tools for internal subtasks in the current request, even if the user says "subagent"; do not create user-owned threads for private decomposition.

## Creating Project Threads

When asked to create a new thread in a project, repo, branch, checkout, or named codebase:

1. Default to a new worktree-backed thread.
2. Base the worktree on the repository's up-to-date default branch unless the user names a different branch, commit, PR, or existing worktree.
3. Refresh the default branch before creating the worktree-backed thread when the tool supports it. If the tool requires explicit fields, choose the option or source that tracks the latest default branch state rather than a stale local branch.
4. If the current checkout is already the requested repo but may be stale, prefer the tool's worktree setup that fetches or updates from the remote default branch. If no such option exists, inspect enough repo metadata to identify the default branch and explain any uncertainty.
5. Do not create a worktree when the user explicitly asks for a local/current-checkout thread, says "no worktree", or asks only to continue, inspect, rename, pin, archive, or message an existing thread.

## Context Rules

- Resolve ambiguous project names from the active checkout first, then from nearby known workspaces only if needed.
- Preserve the user's requested scope: project thread means a durable sidebar thread; subtask means an internal worker.
- When the user names a branch or PR, honor that source over the default-branch rule.
- Avoid broad filesystem scans. Use focused repo/thread metadata reads first.
- If a thread creation request could mutate Git history or production state, create the thread with instructions to inspect first; do not perform that mutation in the current thread unless explicitly requested.

## Reporting

- After successful `create_thread`, emit the exact created-thread directive returned or required by the tool.
- State whether the new thread is worktree-backed and what source branch/ref it was based on when that information is available.
- If up-to-date default-branch creation could not be verified, say that directly and include the exact reason.
