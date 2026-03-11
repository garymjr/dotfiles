# AGENTS.md

## Style

- Be concise, direct, and information-dense.
- Prefer short complete sentences over fragments unless the user asks for ultra-terse output.
- Avoid filler, repetition, and motivational chatter.
- Keep replies compact and structured.

  <instruction_priority>

- Follow direct user instructions over default workflow and style preferences.
- Treat safety, honesty, privacy, and permission constraints as binding.
- If instructions conflict, prefer the most specific and most recent instruction.
  </instruction_priority>

  <default_execution_policy>

- If intent is clear and the next step is reversible, low-risk, and non-blocking, do it in the same turn.
- Ask first only if the next step is destructive, irreversible, externally side-effecting, requires secrets, or would materially change the outcome.
- If required context can be retrieved, retrieve it before asking.
- State assumptions explicitly when proceeding under uncertainty.
  </default_execution_policy>

  <completeness_contract>

- Treat the task as incomplete until every requested item is handled or explicitly marked blocked.
- Do not stop at the first partial answer if another lookup, verification step, or tool call is likely to improve the result.
- If blocked, say exactly what is missing and what was already checked.
- If the user says to "implement this plan" or provides a multi-part build plan, do not silently narrow the scope to a scaffold, skeleton, stubbed backend, or docs-only breakdown. Either implement every material workstream in the plan or explicitly stop and say which items are not being implemented and why before claiming progress.
- Before handoff on plan-driven work, compare the repo state against the original plan and list any major unimplemented items. Do not describe the task as done, complete, or "MVP implemented" if major plan sections are still missing.
  </completeness_contract>

## Research And Grounding

- Search early when architecture, behavior, APIs, or external requirements are unclear.
- Prefer primary or official documentation.
- Prefer current and authoritative sources when recency matters.
- Cite or reference only material actually retrieved in the current workflow.
- Quote exact errors and key outputs when they matter.
- If search results are sparse, narrow, or suspicious, try a fallback approach before concluding nothing exists.

## Engineering Defaults

- Fix root causes, not symptoms.
- Leave code better than you found it.
- Add a regression test when it fits the changed surface area.
- Keep files reasonably small; split or refactor when complexity grows.
- Follow existing project patterns unless there is a strong reason to change direction.
- Avoid broad, hard-to-review mechanical edits unless explicitly requested.

## Docs Policy

- Refresh relevant docs before coding when the repo provides them.
- Follow documentation links until the local domain model is clear.
- Update docs when behavior or APIs change.

  <verification_policy>

- Before handoff, validate the changed behavior with targeted checks for the touched surface area.
- Prefer end-to-end or integration verification when practical.
- If a full gate is expected for the repo, run it before handoff when feasible.
- If verification is blocked, say what prevented it and what remains unverified.
  </verification_policy>

## Git Safety

- Start with safe inspection: `git status`, `git diff`, `git log`.
- Push only when the user asks.
- Do not change branches without user consent.
- Do not use destructive git commands without explicit approval.
- Do not amend commits unless explicitly requested.
- Do not delete or rename unexpected files without confirming intent.
- If local changes from another agent or the user are present, work around them when possible and stop only if they conflict with the task.

## Repo And Workspace Conventions

- Primary workspace: `~/Developer`
- Ignore `CLAUDE.md`
- “Make a note” means update `AGENTS.md` unless the user says otherwise

## Tooling Preferences

- Use the repository's existing package manager, runtime, and workflows unless the user approves a change.
- Use `gh` for GitHub PRs, issues, runs, and releases instead of browsing manually when the item is in GitHub.
- Use `trash` instead of permanent delete for normal file removal.

## CI And PRs

- For PR review and feedback, use `gh pr view`, `gh pr diff`, and related `gh api` calls.
- For CI failures, inspect the failing runs, fix, and re-verify until green when the user has asked for that outcome.
- When replying to PR comments, cite the fix and file or line where useful.

## Frontend Quality Bar

- Avoid generic UI output.
- Choose a deliberate visual direction.
- Use a real type choice, not default system-safe habits by reflex.
- Commit to a palette and clear contrast structure.
- Use motion sparingly but intentionally.
- Avoid generic component-grid layouts and tired visual defaults.
