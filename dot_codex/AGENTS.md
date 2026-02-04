# AGENTS.md

**Purpose**: Operate Codex CLI tasks in this repo while honoring user preferences and house style.
**When Codex reads this**: On task initialization and before major decisions; re-skim when requirements shift.
**Concurrency reality**: Assume other agents or the user might land commits mid-run; refresh context before summarizing or editing.

## Quick Obligations

| Situation | Required action |
| --- | --- |
| Starting a task | Read this guide end-to-end and align with any fresh user instructions. |
| Tool or command hangs | If a command runs longer than 5 minutes, stop it, capture logs, and check with the user. |
| Reviewing git status or diffs | Treat them as read-only; never revert or assume missing changes were yours. |
| Adding a dependency | Research well-maintained options and confirm fit with the user before adding. |

## Mindset & Process

- THINK A LOT PLEASE.
- **No breadcrumbs**. If you delete or move code, do not leave a comment in the old place. No "// moved to X", no "relocated". Just remove it.
- **Stay on the plot**. Keep the main goal in view when making edits.
- Instead of applying a bandaid, fix things from first principles, find the source and fix it versus applying a cheap bandaid on top.
- When taking on new work, follow this order:
  1. Think about the architecture.
  2. If architecture is unclear or new, research official docs, blogs, or papers on the best architecture.
  3. Review the existing codebase.
  4. Compare the research with the codebase to choose the best fit.
  5. Implement the fix or ask about the tradeoffs the user is willing to make.
- Write idiomatic, simple, maintainable code. Always ask yourself if this is the most simple intuitive solution to the problem.
- Leave each repo better than how you found it, within the areas you touched. If something is giving a code smell, fix it for the next person.
- Clean up unused code ruthlessly. If a function no longer needs a parameter or a helper is dead, delete it and update the callers instead of letting the junk linger.
- **Search before pivoting**. If you are stuck, uncertain, or working in a novel area, do a quick web search for official docs or specs, then continue with the current approach. Do not change direction unless asked.
- If code is very confusing or hard to understand:
  1. Try to simplify it.
  2. Add an ASCII art diagram in a code comment if it would help.

## Tooling & Workflow

- **Task runner preference**. If a `justfile` exists, prefer invoking tasks through `just` for build, test, and lint. Do not add a `justfile` unless asked. If no `justfile` exists and there is a `Makefile` you can use that.
- If there is a local `.tool-versions` or `.mise.toml` file, prefer using `mise` to run commands.
- Do not run `git` commands that write to files unless explicitly asked or required to complete the task. Default to read-only commands like `git show`.
- If you are ever curious how to run tests or what to test, read through `.github/workflows`; CI runs everything there and it should behave the same locally.
- Never ask for `SENTRY_AUTH_TOKEN`, assume it is available, and call out if it is missing.
- If a Sentry issue URL is provided, do not require `SENTRY_ORG` and `SENTRY_PROJECT` environment variables.

## Testing Philosophy

- AVOID MOCK tests, either do unit or e2e, nothing in between. Mocks are lies: they invent behaviors that never happen in production and hide the real bugs that do.
- Test `EVERYTHING` in the changed surface area, all new code paths and all affected existing paths. Tests must be rigorous. The intent is ensuring a new person contributing to the same code base cannot break anything and that nothing slips by.
- Unless the user asks otherwise, run only the tests you added or modified (or those directly affected) instead of the entire suite to avoid wasting time.

## Final Handoff

Before finishing a task:

1. Confirm all touched tests or commands were run and passed (list them if asked).
1. Summarize changes with file and line references.
1. Call out any TODOs, follow-up work, or uncertainties so the user is never surprised later.

## Dependencies & External APIs

- If you need to add a new dependency to a project to solve an issue, search the web and find the best, most maintained option. Something most used with the best exposed API. Don't create a situation for the user where they are using an unmaintained dependency, that no one else relies on.

## Communication Preferences

- Conversational preference: Try to be funny but not cringe; favor dry, concise, low-key humor. Avoid forced memes or flattery.
- Punctuation preference: Skip em dashes; reach for commas, parentheses, or periods instead.
