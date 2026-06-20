---
name: cli-sandbox-skill-maintenance
description: Maintain CLI-specific Codex skills from recent sandbox, permission, cache, and tool failure evidence in sessions or rollout summaries.
---

# CLI Sandbox Skill Maintenance

## Overview

Make the sandbox-learning loop repeatable: inspect recent Codex evidence, identify recurring CLI-specific failures, and encode preventative guidance in the relevant CLI skill. Do not create a generic sandbox triage skill; each frequently affected CLI should have its own skill or section.

## Workflow

1. Run the bundled scanner for recent evidence:

```bash
python3 ~/.codex/skills/cli-sandbox-skill-maintenance/scripts/scan_cli_sandbox_issues.py --days 7
```

2. Read the highest-signal evidence files named by the report.
   - Prefer rollout summaries first because they are already compressed and less likely to contain sensitive raw transcript data.
   - Open raw session JSONL only when the summary is insufficient and exact command/error text is needed.
   - Avoid dumping raw session lines into the conversation; summarize the command, tool, error, and outcome.

3. Classify each recurring failure by CLI, not by generic failure mode.
   - Examples: `swiftpm-cli` for `swift build` / `swift test`, `go-cli` for `go test`, `aws-cli` for SSO/cache access, `git-cli` for worktree metadata, `mise` for trust/cache behavior, `opentofu` for `tofu` local state and plugin cache.
   - If a CLI already has a skill, update that skill.
   - If no skill exists and the pattern is repeated or high-friction, create a new `<cli>-cli` skill unless the repo already uses a more natural skill name.

4. Write preventative guidance, not after-the-fact triage.
   - Prefer instructions that avoid the failure before the first run: temp cache env vars, scratch paths, trusted wrappers, exact-command escalation, or known non-blocking warnings.
   - Include safety limits: no broad env dumps, no secret/cache contents, no production mutation unless explicitly authorized, no destructive Git/filesystem work without exact approval.
   - Keep each skill concise and CLI-specific.

5. Validate every created or modified skill:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py ~/.codex/skills/<skill-name>
```

6. Verify there are no leftover scaffold markers or accidental generic catch-all skill references by searching the edited skill for template-only phrases.

7. Summarize exact skill files changed, the scanner command used, validation results, and any uncertainty about evidence or skipped CLIs.

## Evidence Rules

- Treat `~/.codex/sessions` as sensitive. Session records may contain prompts, tool schemas, command output, images, or operational context.
- Do not paste secrets, tokens, SSO device codes, PII, production data, or raw cache file contents into skill files or final summaries.
- Prefer line-numbered citations from memory rollout summaries when final memory citations are required.
- If evidence only shows a one-off failure, do not create a new skill unless the cost of recurrence is high and the prevention is narrow.

## Skill Design Rules

- One CLI per skill. Do not add a catch-all sandbox skill.
- Use clear trigger descriptions in frontmatter, including the CLI name and common commands/errors.
- Put command defaults near the top of the skill so future Codex runs see the preventative path quickly.
- Favor exact, narrow command examples over broad policy prose.
- Add scripts only when the repeated process is mechanical and safe to run locally.
