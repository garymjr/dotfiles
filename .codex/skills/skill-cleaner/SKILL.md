---
name: skill-cleaner
description: Audit and clean local Codex skills. Use when Codex needs to review ~/.codex/skills, detect skills unused in recent sessions, disable stale skills, or shorten skill descriptions so total always-loaded skill metadata stays within a small context budget.
---

# Skill Cleaner

## Workflow

1. Run `scripts/skill_cleaner.py --skills-dir ~/.codex/skills --sessions-dir ~/.codex/sessions --days 30`.
2. Review the report before editing anything. Treat a missing sessions directory or unfamiliar log shape as uncertainty, not evidence that every skill is unused.
3. If the user asked to disable stale skills, rerun with `--disable-unused` after reviewing the dry-run output. The script moves unused skill folders into `~/.codex/skills.disabled/` instead of deleting them.
4. Tighten descriptions for active skills when the report shows the metadata budget is exceeded or a description is obviously verbose. Keep frontmatter to `name` and `description` only.
5. Validate changed skills with the skill creator validator when available:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py ~/.codex/skills/<skill-name>
```

## Cleanup Rules

- Default to dry-run for disables and description edits.
- Never delete skill folders as part of cleanup; move disabled skills to `~/.codex/skills.disabled/`.
- Do not disable `.system` skills unless the user explicitly asks.
- Preserve skills used in the last 30 days, unless the user gives a different window.
- Count explicit `$skill-name` mentions, `/path/to/skill-name/SKILL.md` references, and loaded skill paths in recent session logs as usage.
- Use the script's approximate token estimate for triage, then edit descriptions manually for clarity. The total description budget is 2% of GPT 5.5's context limit unless the user supplies a different limit.
- Prefer specific trigger language over long explanations. A good description names the task, target files or systems, and concrete situations that should invoke the skill.

## Script Notes

`scripts/skill_cleaner.py` is dependency-free and safe to run from any directory. Useful flags:

- `--days N`: change the recent-session lookback window.
- `--context-limit N`: set GPT 5.5 context size when known; the budget is `N * 0.02`.
- `--budget-tokens N`: override the derived budget directly.
- `--disable-unused`: move unused non-system skills into the disabled directory.
- `--json`: emit machine-readable report output.
