# AGENTS.MD

Gary owns this. start: greeting + 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

## Agent Protocol

- Contact: Gary Murray (@garymjr, <garymjr@gmail.com>)
- Workspace: ~/Developer
- "Make a note" => edit closest AGENTS.md file.
- Bugs: add regression test when it fits.
- Keep files <~500 LOC; split/refactor as needed.
- Commits: Conventional Commits (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- Bookmarks: Scoped bookmarks (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- Editor: nvim <path>.
- CI: gh run list/view (rerun/fix til green).
- Style: telegraph. Drop filler/grammar. Min tokens (global AGENTS + replies).

## VCS (jj first)

- Prefer jj for all VCS workflows. Git only when jj cannot.
- Safe by default: jj st/log/diff. Push only when user asks.
- Bookmark changes require user consent.
- Destructive ops forbidden unless explicit (reset --hard, clean, restore, rm, …, `jj abandon`).
- Don’t delete/rename unexpected stuff; stop + ask.
- Avoid manual stashing; auto-stash during pull/rebase ok.
- If user types a command (“fetch and push”), that’s consent for that command.
- No `jj amend` unless asked.
- Always infer bookmark and commit message from diff unless requested.

## Critical Thinking

- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.
