import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

const REVIEW_CUSTOM_TYPE = "review-mode-context";

const REVIEW_PROMPT = `
You are a code reviewer. Review only uncommitted changes.

Always review:
- Unstaged changes: git diff
- Staged changes: git diff --cached

Ignore input. Do not:
- Review commits, branches, or PRs
- Interpret hashes, branch names, or URLs

If no uncommitted changes exist, say so.

After diffing:
- Identify changed files
- Read full files for context
- Follow existing patterns and conventions
- Do not comment on unchanged code

Primary focus: bugs.
- Logic errors, bad conditionals, missing guards
- Dead or unreachable code
- Realistic edge cases
- Security issues (auth, injection, data exposure)
- Broken error handling

Secondary:
- Structural fit with codebase
- Missed existing abstractions
- Excessive nesting; prefer early returns

Performance:
- Flag only obvious issues (O(n²), N+1, blocking hot paths)

Rules:
- Be certain before calling something a bug
- Review only changed or directly impacted code
- No hypotheticals
- If unsure, say "not sure" and move on
- Style only if clearly violating project conventions

Output:
- Direct, concise, factual
- State severity without exaggeration
- Describe exact trigger conditions
- Easy to scan
- No praise, no filler
`.trim();

export default function reviewExtension(pi: ExtensionAPI) {
  // One-shot flag: inject prompt for the next agent run only
  let reviewArmed = false;

  pi.registerCommand("review", {
    description: "Review uncommitted changes only",
    handler: async (_args, ctx) => {
      reviewArmed = true;

      ctx.ui.notify("Review armed: next turn will review uncommitted changes", "info");

      // Kick off an agent turn. The hidden context is injected in before_agent_start.
      pi.sendMessage(
        {
          customType: "review-command",
          content: "Review all uncommitted changes (staged + unstaged).",
          display: true,
        },
        { triggerTurn: true },
      );
    },
  });

  // Inject hidden system-style context right before the agent starts
  pi.on("before_agent_start", async () => {
    if (!reviewArmed) return;

    return {
      message: {
        customType: REVIEW_CUSTOM_TYPE,
        content: REVIEW_PROMPT,
        display: false, // hidden
      },
    };
  });

  // Disarm after the agent finishes (so it doesn't “stick” forever)
  pi.on("agent_end", async (_event, _ctx) => {
    if (reviewArmed) reviewArmed = false;
  });

  // Optional: persist state each turn (mirrors plan-mode pattern)
  pi.on("turn_start", async () => {
    pi.appendEntry("review-mode", { armed: reviewArmed });
  });

  // Optional: restore state on session start
  pi.on("session_start", async (_event, ctx: ExtensionContext) => {
    const entries = ctx.sessionManager.getEntries();
    const last = [...entries]
      .filter((e: any) => e.type === "custom" && e.customType === "review-mode")
      .pop() as any;

    if (last?.data && typeof last.data.armed === "boolean") {
      reviewArmed = last.data.armed;
    }
  });
}
