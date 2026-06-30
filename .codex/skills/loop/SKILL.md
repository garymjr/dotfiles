---
name: loop
description: Convert a user's concrete request into a bounded Codex goal, gather only the context needed to execute it, work the loop to completion, and stop when the defined outcome is achieved or a real blocker is reached. Use when the user explicitly invokes `$loop`, asks Codex to set a goal, or wants a request handled as a persistent execution loop with a clear stop condition.
---

# Loop

## Overview

Use this skill to turn an actionable request into a finite work loop. The loop starts by defining the goal and ends when the stop condition is met, not when context is exhausted.

## Workflow

1. Restate the user's request as an outcome.
2. Gather enough live context to make the goal specific:
   - Inspect named files, repos, tools, tickets, threads, or artifacts.
   - Use memory only when prior context is likely relevant.
   - Ask only if a missing decision would materially change behavior, security, production data, dependencies, public APIs, or Git history.
3. Create or update the Codex goal when goal tools are available:
   - Use `create_goal` only when no active unfinished goal exists.
   - Do not set `token_budget` unless the user gave an explicit budget.
   - If an active goal exists, continue it unless the new request clearly replaces it.
4. Work in short cycles:
   - Inspect the next narrow context.
   - Make the smallest useful change or run the next validation step.
   - Re-check evidence before deciding the next cycle.
5. Mark the goal complete only when the stop condition is satisfied and no required work remains.
6. Mark the goal blocked only when the same blocker has repeated for at least three consecutive goal turns and no meaningful progress is possible without user input or an external-state change.

## Goal Shape

Write goals with three parts:

```text
Objective: <specific user-visible outcome>
Done when: <observable stop condition>
Out of scope: <nearby work that should not extend the loop>
```

Prefer concrete deliverables and verification over broad intent:

```text
Objective: Create and validate a personal Codex skill named loop.
Done when: SKILL.md and agents/openai.yaml exist in the discoverable skills directory, quick_validate.py passes, and the final response reports the files and validation command.
Out of scope: Broad cleanup of unrelated skills or Codex configuration.
```

Avoid run-on goals:

```text
Objective: Improve the repo.
Done when: It seems better.
Out of scope: None.
```

## Stop Conditions

Every goal must include a stop condition that is:

- Observable: the agent can verify it with files, command output, rendered artifacts, API readback, or explicit user confirmation.
- Finite: it names a completed artifact, command result, published change, answered question, or blocked state.
- Scoped: it excludes adjacent cleanup, speculative improvements, and new product decisions.
- Current: it uses live context gathered in this turn when facts may have changed.

Good stop conditions include:

- A specific test, build, lint, or validation command passes.
- A named file, branch, PR, issue, document, spreadsheet, or artifact contains the requested change.
- A read-only investigation returns a concise answer with evidence and no mutation.
- A mutation requested by the user is verified by readback.
- A blocker is documented with the exact missing approval, credential, external failure, or user decision.

## Execution Rules

- Keep context gathering proportional to the risk and blast radius.
- Prefer local, read-only inspection before edits or mutations.
- For production data, credentials, auth, infrastructure, dependencies, public APIs, or Git history, stop for approval when required by the surrounding instructions.
- Do not broaden the loop because optional improvements are visible.
- If validation fails because of the current work, attempt focused fixes and rerun.
- If validation fails for unrelated reasons, preserve the evidence and report it without expanding the goal.
- Final response: state the completed outcome, key files or commands, validation result, and any unresolved blocker or out-of-scope follow-up.
