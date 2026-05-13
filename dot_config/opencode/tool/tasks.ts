import { tool } from "@opencode-ai/plugin"

export const init = tool({
  description: "Initialize tasks for a project repository",
  args: {},
  async execute(args) {
    return await Bun.$`tasks init --json`.text()
  }
})

export const add = tool({
  description: "Add a new task with optional priority, tags, and body. Always include a body for context.",
  args: {
    title: tool.schema.string().describe("Task title"),
    priority: tool.schema.enum(["low", "medium", "high", "critical"]).optional().describe("Task priority"),
    tags: tool.schema.array(tool.schema.string()).optional().describe("Tags for the task"),
    body: tool.schema.string().describe("Task body/description - why, scope, acceptance criteria")
  },
  async execute(args) {
    const cmd = ["tasks", "add", args.title, "--body", args.body]
    if (args.priority) cmd.push(`--priority=${args.priority}`)
    if (args.tags && args.tags.length > 0) cmd.push("--tags", args.tags.join(","))
    cmd.push("--json")
    return await Bun.$`${cmd}`.text()
  }
})

export const list = tool({
  description: "List tasks with optional filters for status, priority, and tags",
  args: {
    status: tool.schema.enum(["todo", "in_progress", "done"]).optional().describe("Filter by status"),
    priority: tool.schema.enum(["low", "medium", "high", "critical"]).optional().describe("Filter by priority"),
    tags: tool.schema.array(tool.schema.string()).optional().describe("Filter by tags")
  },
  async execute(args) {
    const cmd = ["tasks", "list"]
    if (args.status) cmd.push(`--status=${args.status}`)
    if (args.priority) cmd.push(`--priority=${args.priority}`)
    if (args.tags && args.tags.length > 0) cmd.push("--tags", args.tags.join(","))
    cmd.push("--json")
    return await Bun.$`${cmd}`.text()
  }
})

export const next = tool({
  description: "Show next available tasks to work on",
  args: {
    all: tool.schema.boolean().optional().describe("Show all available tasks including blocked ones")
  },
  async execute(args) {
    const cmd = ["tasks", "next"]
    if (args.all) cmd.push("--all")
    cmd.push("--json")
    return await Bun.$`${cmd}`.text()
  }
})

export const edit = tool({
  description: "Edit a task's status, priority, or add tags",
  args: {
    id: tool.schema.string().describe("Task ID"),
    status: tool.schema.enum(["todo", "in_progress", "done"]).optional().describe("Set task status"),
    priority: tool.schema.enum(["low", "medium", "high", "critical"]).optional().describe("Set task priority"),
    tags: tool.schema.array(tool.schema.string()).optional().describe("Add tags to the task")
  },
  async execute(args) {
    const cmd = ["tasks", "edit", args.id]
    if (args.status) cmd.push(`--status=${args.status}`)
    if (args.priority) cmd.push(`--priority=${args.priority}`)
    if (args.tags && args.tags.length > 0) cmd.push("--tags", args.tags.join(","))
    cmd.push("--json")
    return await Bun.$`${cmd}`.text()
  }
})

export const done = tool({
  description: "Mark a task as done",
  args: {
    id: tool.schema.string().describe("Task ID")
  },
  async execute(args) {
    return await Bun.$`tasks done ${args.id} --json`.text()
  }
})

export const link = tool({
  description: "Link tasks together (create dependency from child to parent)",
  args: {
    child: tool.schema.string().describe("Child task ID"),
    parent: tool.schema.string().describe("Parent task ID")
  },
  async execute(args) {
    return await Bun.$`tasks link ${args.child} ${args.parent} --json`.text()
  }
})

export const tag = tool({
  description: "Add tags to a task",
  args: {
    id: tool.schema.string().describe("Task ID"),
    tags: tool.schema.array(tool.schema.string()).describe("Tags to add")
  },
  async execute(args) {
    return await Bun.$`tasks tag ${args.id} ${args.tags.join(",")} --json`.text()
  }
})

export const deleteTask = tool({
  description: "Delete a task",
  args: {
    id: tool.schema.string().describe("Task ID")
  },
  async execute(args) {
    return await Bun.$`tasks delete ${args.id} --json`.text()
  }
})
