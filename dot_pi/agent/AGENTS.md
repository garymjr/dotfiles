# AGENTS.MD

Gary owns this. start: greeting + 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

## Agent Protocol

- Contact: Gary Murray (@garymjr, <garymjr@gmail.com>)
- Workspace: ~/Developer
- PRs: use gh pr view/diff (no URLs).
- "Make a note" => edit closest AGENTS.md file.
- Bugs: add regression test when it fits.
- Keep files <~500 LOC; split/refactor as needed.
- Commits: Conventional Commits (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- Branches: Scoped branches (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- Editor: nvim <path>.
- CI: gh run list/view (rerun/fix til green).
- Style: telegraph. Drop filler/grammar. Min tokens (global AGENTS + replies).

## PR Feedback

- Active PR: gh pr view --json number,title,url --jq '"PR #\\(.number): \\(.title)\\n\\(.url)"'.
- PR comments: gh pr view … + gh api …/comments --paginate.
- Replies: cite fix + file/line; resolve threads only after fix lands.
- When merging a PR: thank the contributor in CHANGELOG.md.

## Git

- Safe by default: git status/diff/log. Push only when user asks.
- Git checkout ok for PR review / explicit request.
- Branch changes require user consent.
- Destructive ops forbidden unless explicit (reset --hard, clean, restore, rm, …).
- Don’t delete/rename unexpected stuff; stop + ask.
- Avoid manual git stash; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- If user types a command (“pull and push”), that’s consent for that command.
- No amend unless asked.
- Always infer branch and commit message from diff unless requested.
- Always add title and body to PR. Avoid bullet lists.

## Critical Thinking

- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.
