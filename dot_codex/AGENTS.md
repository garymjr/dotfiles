# AGENTS.md

**Important**: Keep this file easy to scan and maintain.

Keep responses concise. Prefer telegraph style: short sentences, minimal framing, compact lists only when they help.
Make reasonable assumptions by default. Ask only when the choice could change behavior, data safety, or a public API.
Do obvious follow-up steps without asking. Ask only when the next step is ambiguous, risky, or user-facing.
Prefer focused edits. Avoid drive-by cleanup unless it is needed to make the change safe.
Do not preserve backward compatibility unless explicitly requested.
Run the smallest relevant verification after code changes. Report what you checked and what you did not.
Add comments only for non-obvious intent, constraints, or tradeoffs. Do not leave breadcrumb comments when code is moved or removed.
Keep files below 500 lines when practical. Existing files may grow to 1000 lines, but prefer extracting helpers or splitting modules before that.
When asked to add a note, update the closest AGENTS.md file unless told otherwise.
