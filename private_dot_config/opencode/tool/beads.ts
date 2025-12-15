import { tool } from "@opencode-ai/plugin";

export const ready = tool({
  description: "Get issues that are ready to work on (no blockers)",
  args: {},
  async execute() {
    return await Bun.$`bd ready`.text();
  },
});

export const create = tool({
  description: "Create a new issue",
  args: {
    title: tool.schema.string().min(1).describe("Title of the issue"),
    type: tool.schema.enum(["task", "bug", "feature"]).describe("Type of the issue"),
  },
  async execute(args) {
    return await Bun.$`bd create --title="${(args as any).title}" --type=${(args as any).type}`.text();
  },
});

export const show = tool({
  description: "Show detailed information about an issue",
  args: {
    id: tool.schema.string().min(1).describe("Issue ID"),
  },
  async execute(args) {
    return await Bun.$`bd show ${(args as any).id}`.text();
  },
});

export const update_status = tool({
  description: "Update the status of an issue",
  args: {
    id: tool.schema.string().min(1).describe("Issue ID"),
    status: tool.schema.enum(["open", "in_progress", "closed"]).describe("New status for the issue"),
  },
  async execute(args) {
    return await Bun.$`bd update ${(args as any).id} --status=${(args as any).status}`.text();
  },
});


export const list = tool({
  description: "List issues by status",
  args: {
    status: tool.schema.enum(["open", "in_progress"]).optional().describe("Status to filter by"),
  },
  async execute(args) {
    const status = (args as any).status as string | undefined;
    if (status !== undefined) {
      return await Bun.$`bd list --status=${status}`.text();
    }
    return await Bun.$`bd list`.text();
  },
});

export const add_dependency = tool({
  description: "Add a dependency between issues",
  args: {
    issue: tool.schema.string().min(1).describe("Issue ID that depends on another"),
    depends_on: tool.schema.string().min(1).describe("Issue ID that the first issue depends on"),
  },
  async execute(args) {
    return await Bun.$`bd dep add ${(args as any).issue} ${(args as any).depends_on}`.text();
  },
});
