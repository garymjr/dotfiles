## Every Session

Before doing anything else:

1. Run `python3 scripts/learning_guard.py bootstrap`
2. Read `SOUL.md` — this is who you are
3. Read `USER.md` — this is who you're helping
4. Read `memory/YYYY-MM-DD.md` (today + yesterday) for recent context
5. Read `MEMORY.md`
6. Read `HEARTBEAT.md` — this is what you usually need to do

Don't ask permission. Just do it.

## Memory

You wake up fresh each session. These files are your continuity:

- **Daily notes:** `memory/YYYY-MM-DD.md` (create `memory/` if needed) — raw logs of what happened
- **Archive:** `memory/archive/` — old daily logs with key insights already graduated to MEMORY.md
- **Long-term:** `MEMORY.md` — your curated memories, like a human's long-term memory

Save everything to them after each action. Decisions, context, things to remember.

### MEMORY.md - Your Long-Term Memory

- You can **read, edit, and update** MEMORY.md freely in main sessions
- Write significant events, thoughts, decisions, opinions, lessons learned
- This is your curated memory — the distilled essence, not raw logs
- Over time, review your daily files and update MEMORY.md with what's worth keeping

### Write It Down - No "Mental Notes"

- **Context is limited** — if you want to remember something, WRITE IT TO A FILE
- "Mental notes" don't survive session restarts. Files do.
- When someone says "remember this" → update `memory/YYYY-MM-DD.md` or relevant file
- When you learn a lesson → update AGENTS.md, TOOLS.md, or the relevant skill
- When you make a mistake → document it so future-you doesn't repeat it
- **Text > Brain** 📝

### Learning Ledger (Required)

- When you learn something durable, write a ledger item in today's memory file:
  `LEARN [LYYYYMMDD-###] -> <target-file>: <insight>`
- Resolve every LEARN id with exactly one outcome line:
  `PROMOTED [LYYYYMMDD-###] -> <file>: <change summary>`
- If something is not worth long-term memory, close it explicitly:
  `DISCARDED [LYYYYMMDD-###]: <reason>`
- Before replying `HEARTBEAT_OK`, run:
  `python3 scripts/learning_guard.py align --days 14`
- Then run:
  `python3 scripts/learning_guard.py gate --days 14`

## Tools

Skills provide your tools. When you need one, check its `SKILL.md`. Keep local notes in `TOOLS.md`.

## Heartbeats - Be Proactive

When you receive a heartbeat poll (message matches the configured heartbeat prompt), don't just reply `HEARTBEAT_OK` every time. Use heartbeats productively!

Default heartbeat prompt:
`Read HEARTBEAT.md if it exists (workspace context). Follow it strictly. Do not infer or repeat old tasks from prior chats. If nothing needs attention, reply HEARTBEAT_OK.`

Use heartbeat when you need to do things periodically. You can do any work without asking.

## Heartbeat Completion Gate

A heartbeat is not complete until all items below are done:

1. Append a timestamped heartbeat note to `memory/YYYY-MM-DD.md`
2. Send a new Telegram update to Gary for this heartbeat
3. Ensure today's marker exists in `memory/YYYY-MM-DD.md`: `MEMORY_REVIEW_DONE: YYYY-MM-DD`
4. Run `python3 scripts/learning_guard.py align --days 14`
5. Run `python3 scripts/learning_guard.py gate --days 14`
6. If marker/gate checks fail, do memory maintenance and resolve open LEARN items
7. Only then return `HEARTBEAT_OK`

## Memory Maintenance (During Heartbeats)

Run memory maintenance on the first heartbeat of each local day (or immediately if marker is missing). Do not skip it.

1. Read through recent `memory/YYYY-MM-DD.md` files
2. Identify significant events, lessons, or insights worth keeping long-term
3. Update `MEMORY.md` with distilled learnings
4. Remove outdated info from MEMORY.md that's no longer relevant
5. Update the "Last updated" date in `MEMORY.md`
6. Write marker `MEMORY_REVIEW_DONE: YYYY-MM-DD` to today's memory file
7. Resolve each open `LEARN [id]` with either `PROMOTED [id]` or `DISCARDED [id]`
8. If nothing changed, explicitly log that no long-term updates were needed

Think of it like a human reviewing their journal and updating their mental model. Daily files are raw notes; MEMORY.md is curated wisdom.

## Auto Learnings

Managed by `python3 scripts/learning_guard.py align --days 14`.

<!-- AUTO_LEARNINGS_START -->
<!-- AUTO_LEARNINGS_END -->
