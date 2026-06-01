---
name: simplify-changes
description: Review current code changes for reuse opportunities, code quality issues, and efficiency problems, then simplify the implementation and apply fixes. Use when Codex should inspect a git diff or recently touched files, reduce complexity, remove duplication, replace hand-rolled logic with existing utilities, and clean up hacky or wasteful patterns before handing work back.
---

# Simplify Changes

Review the current change set with a cleanup mindset. Prefer direct fixes over long commentary. Keep intended behavior unless simplification clearly removes accidental complexity.

## Gather Scope

1. If the current directory is inside a git work tree, decide the review target from git:
   - Use `git diff HEAD` when there are staged changes.
   - Otherwise use `git diff`.
2. If git is unavailable or the diff is empty, review the files the user mentioned.
3. If no files were mentioned, review the most recently modified files touched in the current work.
4. Keep the full diff or file set available for every review pass.

## Run Review Passes

Cover the same scope three ways:

1. Reuse review
2. Quality review
3. Efficiency review

When subagents are permitted in the environment and the user explicitly asked for parallel agent work, launch all three passes in parallel in one batch and pass each agent the full diff plus the changed-file list. Otherwise perform the three passes locally.

Do not wait for one pass to finish before starting the next unless the environment forces that.

## Reuse Review

Look for existing helpers, utilities, components, hooks, types, and patterns that should replace newly written code.

Check for:

1. New functions that duplicate existing functionality.
2. Inline logic that should use an existing shared utility.
3. Adjacent code patterns that could be reused instead of rewritten.
4. Newly introduced constants, parsing, guards, or transforms that already exist elsewhere.

Search with `rg` in the changed area first, then in obvious shared locations.

## Quality Review

Look for code that works but is clumsy, overfitted, or harder to maintain than necessary.

Check for:

1. Redundant state or cached values that could be derived.
2. Parameter sprawl instead of better structure.
3. Copy-paste with slight variation that should be unified.
4. Leaky abstractions or broken module boundaries.
5. Stringly-typed code where existing constants, unions, or types should be used.
6. UI wrappers or nesting that add no layout value.
7. Comments that explain obvious behavior instead of non-obvious constraints.

## Efficiency Review

Look for unnecessary work in the changed code and on surrounding hot paths.

Check for:

1. Redundant computation, repeated reads, or duplicated calls.
2. Sequential work that could run concurrently.
3. Blocking work added to startup, request, render, or polling paths.
4. Recurring no-op updates that should be guarded by change detection.
5. Pre-checks for existence that should be replaced with direct operation plus error handling.
6. Missing cleanup or unbounded accumulation.
7. Overly broad reads or loads when only a subset is needed.

## Fix Findings

Aggregate the actionable findings from all passes and fix them directly.

1. Prefer the smallest change that meaningfully simplifies the code.
2. Remove dead code and unnecessary comments while fixing issues.
3. If a finding is a false positive or not worth addressing, skip it without extended debate.
4. If simplification changes behavior or crosses a product boundary, pause and ask the user.

## Validate

After edits:

1. Re-read the touched code to confirm the simplification actually reduced complexity.
2. Run targeted tests or checks when they exist and are practical.
3. Summarize what changed, or confirm the code was already clean if nothing needed fixing.

## Subagent Prompt Shape

When using subagents, keep prompts short and task-local. Ask for actionable findings only.

Example reuse pass prompt:

`Review this diff for missed reuse opportunities. Focus on existing helpers, shared abstractions, and duplicated logic. Return only actionable findings.`

Example quality pass prompt:

`Review this diff for code quality issues that should be simplified. Focus on redundant state, parameter sprawl, copy-paste, leaky abstractions, stringly-typed code, unnecessary nesting, and unnecessary comments. Return only actionable findings.`

Example efficiency pass prompt:

`Review this diff for efficiency issues. Focus on unnecessary work, missed concurrency, hot-path bloat, recurring no-op updates, unnecessary existence checks, memory issues, and overly broad operations. Return only actionable findings.`
