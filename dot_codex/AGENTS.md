# AGENTS.MD

Gary owns this. start: greeting + 1 motivating line.

## Agent Protocol

- Contact: Gary Murray (@garymjr, <garymjr@gmail.com>)
- Workspace: ~/Developer.
- Default flow: read -> plan -> edit -> test -> report.
- PR body minimum: what changed, why, how verified, risk.
- “Make a note” => edit AGENTS.md (shortcut; not a blocker). Ignore CLAUDE.md.
- Guardrails: use `trash` CLI for deletes (not `rm`).
- Bugs: add regression test when it fits. Skip only if heavy; say why.
- Keep files <~500 LOC; split/refactor as needed; exceptions: generated, fixtures, lockfiles.
- Commits: Conventional Commits (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- CI: gh run list/view (rerun once for flakes; if still red, fix or ask).
- Web: search for volatile/unknown facts; prefer primary docs; quote exact errors; prefer 2024–2025 sources.
- Style: telegraph. Drop filler/grammar. Min tokens (global AGENTS + replies).
- Decision: when unsure, read more code/docs before asking.
- Errors: quote exact error; retry once if safe; then ask with 2–3 options.
- Tests: run smallest relevant test; avoid full suite unless asked or tiny repo.
- Secrets: never paste or commit keys; redact in output.
- Lockfiles: avoid edits unless needed by change.

## PR Feedback

- Active PR: gh pr view --json number,title,url --jq '"PR #\\(.number): \\(.title)\\n\\(.url)"'.
- PR comments: gh pr view … + gh api …/comments --paginate.
- Replies: cite fix + file/line; resolve threads only after fix lands.

## Git

- Safe by default: git status/diff/log. Push only when user asks.
- git checkout ok for PR review / explicit request.
- Branch changes require user consent.
- Destructive ops forbidden unless explicit (reset --hard, clean, restore, rm, …).
- Don’t delete/rename unexpected stuff; stop + ask.
- No repo-wide S/R scripts; keep edits small/reviewable.
- Avoid manual git stash; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- If user types a command (“pull and push”), that’s consent for that command.
- No amend unless asked.
- Big review: git --no-pager diff --color=never.

## Critical Thinking

- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.

Last updated: 2026-01-22.
