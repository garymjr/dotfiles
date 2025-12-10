import { tool } from "@opencode-ai/plugin/tool"
import { z } from "zod"
import { $ } from "bun"

const BeadsCommandSchema = z.enum([
  "init", "create", "list", "show", "update", "close",
  "ready", "dep_add", "dep_remove", "dep_tree", "dep_cycles",
  "status", "config_get", "config_set", "config_list"
])

const CreateArgsSchema = z.object({
  title: z.string().describe("Issue title"),
  description: z.string().optional().describe("Issue description"),
  priority: z.number().min(0).max(4).optional().describe("Priority (0-4, 0=highest)"),
  assignee: z.string().optional().describe("Assignee name"),
  tags: z.array(z.string()).optional().describe("Issue tags"),
  type: z.string().optional().describe("Issue type"),
  json: z.boolean().optional().describe("Output JSON format")
})

const UpdateArgsSchema = z.object({
  issue: z.string().describe("Issue ID (e.g., bd-1)"),
  status: z.enum(["open", "in_progress", "done", "closed"]).optional().describe("Issue status"),
  priority: z.number().min(0).max(4).optional().describe("Priority (0-4, 0=highest)"),
  assignee: z.string().optional().describe("Assignee name"),
  description: z.string().optional().describe("Issue description"),
  json: z.boolean().optional().describe("Output JSON format")
})

const ListArgsSchema = z.object({
  status: z.enum(["open", "in_progress", "done", "closed"]).optional().describe("Filter by status"),
  priority: z.number().min(0).max(4).optional().describe("Filter by priority"),
  assignee: z.string().optional().describe("Filter by assignee"),
  limit: z.number().optional().describe("Limit number of results"),
  json: z.boolean().optional().describe("Output JSON format")
})

const ShowArgsSchema = z.object({
  issue: z.string().describe("Issue ID (e.g., bd-1)"),
  json: z.boolean().optional().describe("Output JSON format")
})

const CloseArgsSchema = z.object({
  issues: z.array(z.string()).describe("Issue IDs to close"),
  reason: z.string().optional().describe("Reason for closing"),
  json: z.boolean().optional().describe("Output JSON format")
})

const DepAddArgsSchema = z.object({
  from: z.string().describe("Issue ID that depends (e.g., bd-1)"),
  to: z.string().describe("Issue ID that blocks (e.g., bd-2)"),
  type: z.enum(["blocks", "related", "parent-child", "discovered-from"]).optional().describe("Dependency type"),
  json: z.boolean().optional().describe("Output JSON format")
})

const ReadyArgsSchema = z.object({
  limit: z.number().optional().describe("Limit number of results"),
  assignee: z.string().optional().describe("Filter by assignee"),
  priority: z.number().min(0).max(4).optional().describe("Filter by priority"),
  json: z.boolean().optional().describe("Output JSON format")
})

const InitArgsSchema = z.object({
  prefix: z.string().optional().describe("Custom prefix for issues"),
  json: z.boolean().optional().describe("Output JSON format")
})

const DepRemoveArgsSchema = z.object({
  from: z.string().describe("Issue ID that depends (e.g., bd-1)"),
  to: z.string().describe("Issue ID that blocks (e.g., bd-2)"),
  json: z.boolean().optional().describe("Output JSON format")
})

const DepTreeArgsSchema = z.object({
  issue: z.string().describe("Issue ID (e.g., bd-1)"),
  json: z.boolean().optional().describe("Output JSON format")
})

const ConfigGetArgsSchema = z.object({
  key: z.string().describe("Configuration key"),
  json: z.boolean().optional().describe("Output JSON format")
})

const ConfigSetArgsSchema = z.object({
  key: z.string().describe("Configuration key"),
  value: z.string().describe("Configuration value"),
  json: z.boolean().optional().describe("Output JSON format")
})

async function executeBdCommand(args: string[], json: boolean = false): Promise<string> {
  try {
    const cmd = ["bd", ...args]
    if (json) {
      cmd.push("--json")
    }

    const result = await $`${cmd}`.text()
    return result
  } catch (error: any) {
    throw new Error(`Beads command failed: ${error.stderr || error.message}`)
  }
}

async function executeBdCommandJSON(args: string[]): Promise<any> {
  try {
    const result = await executeBdCommand(args, true)
    return JSON.parse(result)
  } catch (error) {
    throw new Error(`Failed to execute beads command or parse JSON: ${error}`)
  }
}

export default tool({
  description: "Intelligent wrapper for beads (bd) issue tracker - dependency-aware issue management for AI agents",
  args: {
    command: BeadsCommandSchema.describe("Command to execute"),
    create_args: CreateArgsSchema.optional().describe("Arguments for create command"),
    update_args: UpdateArgsSchema.optional().describe("Arguments for update command"),
    list_args: ListArgsSchema.optional().describe("Arguments for list command"),
    show_args: ShowArgsSchema.optional().describe("Arguments for show command"),
    close_args: CloseArgsSchema.optional().describe("Arguments for close command"),
    dep_add_args: DepAddArgsSchema.optional().describe("Arguments for dep_add command"),
    dep_remove_args: DepRemoveArgsSchema.optional().describe("Arguments for dep_remove command"),
    dep_tree_args: DepTreeArgsSchema.optional().describe("Arguments for dep_tree command"),
    ready_args: ReadyArgsSchema.optional().describe("Arguments for ready command"),
    init_args: InitArgsSchema.optional().describe("Arguments for init command"),
    config_get_args: ConfigGetArgsSchema.optional().describe("Arguments for config_get command"),
    config_set_args: ConfigSetArgsSchema.optional().describe("Arguments for config_set command"),
    json: z.boolean().optional().describe("Output JSON format for all commands")
  },
  async execute(args) {
    const { command, json = false } = args

    try {
      switch (command) {
        case "init": {
          const { init_args } = args
          if (!init_args) throw new Error("init_args required for init command")

          const cmdArgs = ["init"]
          if (init_args.prefix) cmdArgs.push("--prefix", init_args.prefix)

          return await executeBdCommand(cmdArgs, init_args.json || json)
        }

        case "create": {
          const { create_args } = args
          if (!create_args) throw new Error("create_args required for create command")

          const cmdArgs = ["create", create_args.title]

          if (create_args.description) cmdArgs.push("--description", create_args.description)
          if (create_args.priority !== undefined) cmdArgs.push("--priority", create_args.priority.toString())
          if (create_args.assignee) cmdArgs.push("--assignee", create_args.assignee)
          if (create_args.tags) cmdArgs.push("--labels", ...create_args.tags)
          if (create_args.type) cmdArgs.push("--type", create_args.type)

          return await executeBdCommand(cmdArgs, create_args.json || json)
        }

        case "list": {
          const { list_args } = args
          const cmdArgs = ["list"]

          if (list_args?.status) cmdArgs.push("--status", list_args.status)
          if (list_args?.priority !== undefined) cmdArgs.push("--priority", list_args.priority.toString())
          if (list_args?.assignee) cmdArgs.push("--assignee", list_args.assignee)
          if (list_args?.limit) cmdArgs.push("--limit", list_args.limit.toString())

          return await executeBdCommand(cmdArgs, list_args?.json || json)
        }

        case "show": {
          const { show_args } = args
          if (!show_args) throw new Error("show_args required for show command")

          return await executeBdCommand(["show", show_args.issue], show_args.json || json)
        }

        case "update": {
          const { update_args } = args
          if (!update_args) throw new Error("update_args required for update command")

          const cmdArgs = ["update", update_args.issue]

          if (update_args.status) cmdArgs.push("--status", update_args.status)
          if (update_args.priority !== undefined) cmdArgs.push("--priority", update_args.priority.toString())
          if (update_args.assignee) cmdArgs.push("--assignee", update_args.assignee)
          if (update_args.description) cmdArgs.push("--description", update_args.description)

          return await executeBdCommand(cmdArgs, update_args.json || json)
        }

        case "close": {
          const { close_args } = args
          if (!close_args) throw new Error("close_args required for close command")

          const cmdArgs = ["close", ...close_args.issues]

          if (close_args.reason) cmdArgs.push("--reason", close_args.reason)

          return await executeBdCommand(cmdArgs, close_args.json || json)
        }

        case "ready": {
          const { ready_args } = args
          const cmdArgs = ["ready"]

          if (ready_args?.limit) cmdArgs.push("--limit", ready_args.limit.toString())
          if (ready_args?.assignee) cmdArgs.push("--assignee", ready_args.assignee)
          if (ready_args?.priority !== undefined) cmdArgs.push("--priority", ready_args.priority.toString())

          return await executeBdCommand(cmdArgs, ready_args?.json || json)
        }

        case "dep_add": {
          const { dep_add_args } = args
          if (!dep_add_args) throw new Error("dep_add_args required for dep_add command")

          const cmdArgs = ["dep", "add", dep_add_args.from, dep_add_args.to]

          if (dep_add_args.type) cmdArgs.push("--type", dep_add_args.type)

          return await executeBdCommand(cmdArgs, dep_add_args.json || json)
        }

        case "dep_remove": {
          const { dep_remove_args } = args
          if (!dep_remove_args) throw new Error("dep_remove_args required for dep_remove command")

          return await executeBdCommand(["dep", "remove", dep_remove_args.from, dep_remove_args.to], dep_remove_args.json || json)
        }

        case "dep_tree": {
          const { dep_tree_args } = args
          if (!dep_tree_args) throw new Error("dep_tree_args required for dep_tree command")

          return await executeBdCommand(["dep", "tree", dep_tree_args.issue], dep_tree_args.json || json)
        }

        case "dep_cycles": {
          return await executeBdCommand(["dep", "cycles"], json)
        }

        case "status": {
          return await executeBdCommand(["status"], json)
        }

        case "config_get": {
          const { config_get_args } = args
          if (!config_get_args) throw new Error("config_get_args required for config_get command")

          return await executeBdCommand(["config", "get", config_get_args.key], config_get_args.json || json)
        }

        case "config_set": {
          const { config_set_args } = args
          if (!config_set_args) throw new Error("config_set_args required for config_set command")

          return await executeBdCommand(["config", "set", config_set_args.key, config_set_args.value], config_set_args.json || json)
        }

        case "config_list": {
          return await executeBdCommand(["config", "list"], json)
        }

        default:
          throw new Error(`Unknown command: ${command}`)
      }
    } catch (error) {
      return `Error executing beads command: ${error}`
    }
  }
})
