---
name: rule-maintenance
description: Maintain ~/.codex/rules/default.rules from recent Codex approval evidence; add narrow prefix_rule entries, dedupe rules, or remove stale rules.
---

# Rule Maintenance

## Workflow

1. Run the report first:

```bash
python3 ~/.codex/skills/rule-maintenance/scripts/rule_maintenance.py --days 7
```

2. Read `~/.codex/rules/default.rules` directly before editing. `~/.codex` is not a git worktree, so validate with direct readback rather than `git status`.
3. Add only rules that meet all criteria:
   - The report shows repeated recent `require_escalated` approvals.
   - The proposed prefix is narrow and non-duplicate.
   - The command family is read-only or low-risk local workflow glue.
   - The rule does not expose secrets, PII, credentials, production data, or broad interpreter access.
4. Prefer no-op over padding. If no safe non-duplicate rule clears the bar, leave `default.rules` unchanged and say why.
5. Review stale-rule candidates separately. Do not remove a rule only because it was quiet for 7 days; use a longer lookback before removal:

```bash
python3 ~/.codex/skills/rule-maintenance/scripts/rule_maintenance.py --days 90
```

6. Remove a stale rule only when it has no recent usage in the longer window, is not a deliberate baseline rule, and its absence would not force repeated approvals for common read-only investigation. When uncertain, keep the rule and report the uncertainty.
7. After any edit, run the report again and read back the changed stanza(s). If available, run the Codex config/rules validator appropriate for the current install; otherwise direct readback is the minimum verification.

## Safety Rules

- Treat mutating infrastructure, cloud identity, destructive filesystem, broad interpreter, and secret-bearing commands as skip-by-default, even if frequent.
- Avoid broad prefixes such as `python3`, `python`, `bash`, `sh`, `node`, `aws`, `gh`, `terraform`, `rm`, or `git` without enough fixed subcommands.
- Do not add a rule when the observed command includes shell redirection, heredocs, herestrings, wildcard expansion, environment dumps, or arbitrary inline scripts.
- Count whole `exec_command` approval payloads and explicit `prefix_rule` arrays. Do not rely on grep counts alone because copied logs, diffs, and multiline snippets can overcount.
- Keep comments and justifications specific to the command family and why it is safe.

## Report Guidance

The script emits:

- `Observed approval prefixes`: recent approval requests grouped by proposed `prefix_rule` or inferred command prefix.
- `Candidate additions`: repeated prefixes that are not already present and pass conservative safety heuristics.
- `Stale existing rules`: current rules with no matching observed usage in the selected window.
- `Skipped candidates`: frequent but unsafe, broad, duplicate, or uncertain families.

Use the report as evidence, not as an automatic patch. Include exact files, commands, counts, and unresolved uncertainty in the final summary.
