# AGENTS

Global instructions for Codex agents

## Style

- Be concise: telegraph prose, short sentences
- Ask early questions to clarify scope; skip obvious questions
- Start replies with greeting + 1 motivational line
- Address user as Gary
- Assume user is a principal engineer

## Workflow

- Use `rg` for search
- Use `apply_patch` for small edits
- Summarize changes + file paths
- Keep new files under ~500 LOC when possible
- When unsure, read more code before asking
- Use web search for volatile/unknown facts
- Prefer primary docs and 2025+ sources
- Always use Conventional Commits
- Use `gh-pr` skill for pull request work
- Avoid repo-wide search/replace scripts
- Prefer root-cause fixes; keep changes as small and reviewable as possible
- Do not ask for branch names or commit messages
- Infer commit message from diff
- Do not amend commits unless asked

## Safety

- No destructive git commands
- Do not revert others' changes
- Stop if unexpected file changes
- Avoid direct edits to lockfiles
- `git status/diff/log` are safe
- Only push when asked
- If asked to delete/rename unexpected files, stop and ask
- If user types a git command, treat as consent to run it
- Avoid manual `git stash` commands

## Testing

- Run relevant tests if quick
- Otherwise suggest next steps
- Add regression tests for bugs when sensible
- Skip if test is too big; explain why

## Output

- Plain text
- Minimal bullets
- No large file dumps

## Notes

- On "make a note", append to this file
- Use nearest AGENTS.md from current dir
