# HEARTBEAT.md

**⚠️ ZERO QUIET HEARTBEATS. EVER.**

## 0. Always Update Gary (NEVER SILENT)

⚠️ **MANDATORY: Message Gary on Telegram EVERY heartbeat** — even if nothing changed:

- What you checked
- What you found (or "nothing new")
- What's pending/next

**STOP BEFORE SAYING HEARTBEAT_OK:**

1. Did I send a Telegram message to Gary THIS heartbeat?
2. If NO → Use `message` tool NOW. Even just "Checked posts, nothing new."
3. Only after sending → Then HEARTBEAT_OK

**Never reply HEARTBEAT_OK without the Telegram message first.**

⚠️ **COMMON FAILURE MODE:** Thinking "I already told him earlier" counts. IT DOESN'T.

- Each heartbeat is INDEPENDENT
- "Gary notified (msg #X)" referring to earlier message = WRONG
- Must send NEW message THIS heartbeat = RIGHT

## 1. Check Gary's Email Every Heartbeat

Before sending the Telegram update:

1. Check Gary's recent email (new/unread plus latest inbox activity).
2. Identify important-looking emails and include a short summary in the heartbeat update to Gary.
3. For emails that look like spam or junk, apply the `review` label.
4. Report every email labeled `review` in the heartbeat update (sender + subject, concise).

## 2. Check Gary's Calendar Every Heartbeat

Before sending the Telegram update:

1. Use the `calendar` skill to check Gary's upcoming events (today plus the next few days).
2. Include a concise summary of upcoming events in the heartbeat update (title + time + how soon).
3. Look for reminder-worthy items from Gmail that are not on the calendar yet (deadlines, meetings, travel, bills, follow-ups).
4. Recommend events or reminders to add when useful, including anything else Gary should likely be reminded of.
5. If there are no upcoming events and no reminder suggestions, explicitly say so in the heartbeat update.

## 3. Check Weather (Exactly Once Per Day)

Run the Kody Colorado forecast scraper exactly one time per local date (MST). Do not run it more than once unless Gary explicitly asks.

1. Use `date +%F` to get today's local date string.
2. Check `memory/YYYY-MM-DD.md` for marker line: `KODY_FORECAST_DONE: YYYY-MM-DD`.
3. If marker exists, skip the scraper for this heartbeat (already done today).
4. If marker does not exist, run:
   `python3 ~/.config/zigbot/skills/weather/scripts/kody_colorado_forecast.py --max-paragraphs 5`
5. Prefer running this in the morning (05:00-11:59 MST). If morning is missed, run on the first heartbeat after 12:00 MST.
6. Add a brief summary to Gary's Telegram heartbeat update when run:
   - Forecast date
   - Headline
   - 1-2 key forecast points
7. Append this to today's memory file immediately after running:
   - `KODY_FORECAST_DONE: YYYY-MM-DD`
   - 1-3 lines with the brief forecast summary sent to Gary
8. If scraper fails, report failure in the heartbeat update, do not retry repeatedly, and use `curl -s wttr.in/Johnstown+Colorado?0pq` as fallback conditions only.
