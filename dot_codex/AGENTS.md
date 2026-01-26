# AGENTS.MD

Gary owns this. Ultra-brief replies; start: 1 motivating line.

## Essentials (always)

- Workspace: ~/Developer.
- Default flow: read -> plan -> edit -> test -> report. Skip planning for trivial requests.
- “Make a note” => edit AGENTS.md (shortcut; not a blocker). Ignore CLAUDE.md.
- Guardrails: use `trash` CLI for deletes (not `rm`).
- Bugs: add regression test when it fits. Skip only if heavy; say why.
- Keep files <~500 LOC; split/refactor as needed; exceptions: generated, fixtures, lockfiles.
- Style: telegraph. Drop filler/grammar. Min tokens (global AGENTS + replies).
- Hard rule: telegraph-only replies. No filler.
- Decision: when unsure, read more code/docs before asking.
- Errors: quote exact error; retry once if safe; then ask with 2–3 options.
- Tests: run smallest relevant test; avoid full suite unless asked or tiny repo.
- Secrets: never paste or commit keys; redact in output.
- Lockfiles: avoid edits unless needed by change.

## Contact

- Gary Murray (@garymjr, <garymjr@gmail.com>)

## Web + Docs

- Web: search for volatile/unknown facts; prefer primary docs; quote exact errors; prefer 2024–2025 sources.

## CI

- CI: gh run list/view (rerun once for flakes; if still red, fix or ask).

## Commits

- Commits: Conventional Commits (feat|fix|refactor|build|ci|chore|docs|style|perf|test).

## PR Feedback

- Active PR: gh pr view --json number,title,url --jq '"PR #\\(.number): \\(.title)\\n\\(.url)"'.
- PR comments: gh pr view … + gh api …/comments --paginate.
- Replies: cite fix + file/line; resolve threads only after fix lands.
- PRs: don’t use literal newline characters (`\n`) when creating pull requests.
- If user says “PR”, “pull request”, “gh pr”, “review comments”, or “respond to PR feedback”, always use gh-pr skill.

## Git

- Safe by default: git status/diff/log. Push only when user asks.
- git checkout ok for PR review / explicit request.
- Branch changes require implicit consent ok (don’t ask unless unclear).
- Destructive ops forbidden unless explicit (reset --hard, clean, restore, rm, …).
- Don’t delete/rename unexpected stuff; stop + ask.
- No repo-wide S/R scripts; keep edits small/reviewable.
- Avoid manual git stash; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- If user types a command (“pull and push”), that’s consent for that command.
- Don’t ask for branch name/commit message; draft both and proceed unless user says otherwise.
- No amend unless asked.
- Big review: git --no-pager diff --color=never.

## Critical Thinking

- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: if they touch files you edit, read and preserve; if unrelated, ignore. If they block your change or look risky, stop and ask.
