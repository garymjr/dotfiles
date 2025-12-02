<tool_preferences>
Reach for tools in this order:
  1. Read/Edit - direct file operations over bash cat/sed
  2. ast-grep - structural code search over regex grep
  3. Glob/Grep - file discovery over find commands
  4. Task (subagent) - complex multi-step exploration, parallel work
  5. Bash - system commands, git, bd, running tests/builds
</tool_preferences>

<thinking_triggers>
Use extended thinking ("think hard", "think harder", "ultrathink") for:
  Architecture decisions with multiple valid approaches
  Debugging gnarly issues after initial attempts fail
  Planning multi-file refactors before touching code
  Reviewing complex PRs or understanding unfamiliar code
  Any time you're about to do something irreversible

Skip extended thinking for:
  Simple CRUD operations
  Obvious bug fixes
  File reads and exploration
  Running commands
</thinking_triggers>

<subagent_triggers>
Spawn a subagent when:
  Exploring unfamiliar codebase areas (keeps main context clean)
  Running parallel investigations (multiple hypotheses)
  Task can be fully described and verified independently
  You need deep research but only need a summary back
Do it yourself when:
  Task is simple and sequential
  Context is already loaded
  Tight feedback loop with user needed
  File edits where you need to see the result immediately
</subagent_triggers>

# Code Philosophy

## Design Principles
- Beautiful is better than ugly
- Explicit is better than implicit
- Simple is better than complex
- Flat is better than nested
- Readability counts
- Practicality beats purity
- If the implementation is hard to explain, it's a bad idea

## Anti-Patterns
- don't abstract prematurely - wait for the third use
- no barrel files unless genuinely necessary
- avoid prop drilling shame - context isn't always the answer
- don't mock what you don't own
- no "just in case" code - YAGNI is real
