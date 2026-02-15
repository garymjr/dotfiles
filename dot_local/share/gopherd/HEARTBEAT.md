# HEARTBEAT.md

**⚠️ ZERO QUIET HEARTBEATS. EVER.**

## 0. Always Update Gary (NEVER SILENT)

⚠️ **MANDATORY: Message Gary on Telegram EVERY heartbeat** — even if nothing changed.

**STOP BEFORE SAYING HEARTBEAT_OK:**

1. Did I send a Telegram message to Gary THIS heartbeat?
2. If NO → Use bot API to send. Even just "All quiet."
3. Only after sending → Then HEARTBEAT_OK

⚠️ **COMMON FAILURE MODE:** Thinking "I already told him earlier" counts. IT DOESN'T.

- Each heartbeat is INDEPENDENT
- Must send NEW message THIS heartbeat

## 1. Check Gary's Email Every Heartbeat

Before sending the Telegram update:

1. Check Gary's recent email (new/unread plus latest inbox activity).
2. Identify important-looking emails — flag anything that needs attention.
3. For emails that look like spam or junk, apply the `review` label.
4. Note flagged emails in the heartbeat message.

## 2. Check Gary's Calendar a Few Times Per Day

Check the calendar periodically (2-3 times per day is fine), not every heartbeat:

1. Use the `calendar` skill to check upcoming events (today plus next few days).
2. Note any events worth mentioning — birthdays, appointments, deadlines.
3. Reuse the last check result for heartbeats in between full calendar checks.

## 3. Check Weather (Exactly Once Per Day)

Run the Kody Colorado forecast scraper exactly one time per local date (MST). Do not run it more than once unless Gary explicitly asks.

1. Use `date +%F` to get today's local date string.
2. Check `memory/YYYY-MM-DD.md` for marker line: `KODY_FORECAST_DONE: YYYY-MM-DD`.
3. If marker exists, skip the scraper (already done today).
4. If marker does not exist, run:
   `python3 ~/.config/zigbot/skills/weather/scripts/kody_colorado_forecast.py --max-paragraphs 5`
5. Prefer running this in the morning (05:00-11:59 MST). If morning is missed, run on the first heartbeat after 12:00 MST.
6. If scraper fails, use `curl -s wttr.in/Johnstown+Colorado?0pq` as fallback.

## 4. Telegram Message Style (IMPORTANT)

**Write like you're talking to a friend, not filing a report.**

✅ **Do:**
- Lead with what's important or interesting
- Skip the checklist format — just write sentences
- Add light commentary where it adds value ("the usual school stuff", "you can ignore until due")
- Vary the length based on what's happening
- Sign off casually ("— S" or just end naturally)

❌ **Don't:**
- Use emoji headers (📧 Email:, 📅 Calendar:)
- List everything item by item
- Write in telegram-style bullet points
- Say "Heartbeat complete" or use ✅ checkmarks

**Example (good):**
> "Hey Gary — quick pulse. Nothing urgent in email. The usual school stuff from Allyson Garza and John Dumbleton, plus a UCHealth payment reminder you can ignore until due. Jaxson's birthday is tomorrow at 10am @ GetAir (the trampoline place), mom's is Tuesday. Weather was done earlier — looks fine. — S"

**Example (bad):**
> "📧 Email: Raptor Report, UCHealth payment
> 📅 Calendar: Jaxson's Birthday tomorrow
> 🌤️ Weather: Done
> ✅ Heartbeat complete"
