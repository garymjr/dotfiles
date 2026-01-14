/**
 * Tasks CLI Extension - Custom tools for the local-first tasks CLI
 *
 * This extension wraps the `tasks` command-line tool with pi tools.
 * Tasks are stored in .tasks/tasks.json per directory.
 *
 * Features:
 * - tasks_init: Initialize tasks in current directory
 * - tasks_add: Add a new task with optional priority, tags, body
 * - tasks_list: List tasks with filtering (status, priority, tags)
 * - tasks_next: Show next ready tasks (not blocked by dependencies)
 * - tasks_done: Mark a task as done
 * - tasks_edit: Edit task status, priority, tags, or body
 * - tasks_delete: Delete a task
 * - tasks_link: Create dependency link between tasks
 */

import { StringEnum } from "@mariozechner/pi-ai";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Text } from "@mariozechner/pi-tui";
import { Type } from "@sinclair/typebox";

interface TaskJson {
	id: string;
	title: string;
	body?: string;
	status: "todo" | "in_progress" | "done";
	priority: "low" | "medium" | "high" | "critical";
	tags: string[];
	dependencies: string[];
	created_at: number;
	updated_at: number;
	completed_at?: number | null;
}

interface TasksListResponse {
	tasks: TaskJson[];
}

// Status values from tasks CLI
const StatusValues = ["todo", "in_progress", "done"] as const;
const PriorityValues = ["low", "medium", "high", "critical"] as const;

export default function (pi: ExtensionAPI) {
	// tasks_init - Initialize tasks in the current directory
	pi.registerTool({
		name: "tasks_init",
		label: "Tasks Init",
		description: "Initialize tasks in the current directory. Creates .tasks/tasks.json",
		parameters: Type.Object({}),

		async execute(_toolCallId, _params, _onUpdate, _ctx, signal) {
			const result = await pi.exec("tasks", ["init", "--json"], { signal });
			return {
				content: [
					{
						type: "text",
						text: result.code === 0 ? "Tasks initialized in .tasks/tasks.json" : `Error: ${result.stderr}`,
					},
				],
				details: { success: result.code === 0 },
			};
		},

		renderCall(_args, theme) {
			return new Text(theme.fg("toolTitle", theme.bold("tasks_init")), 0, 0);
		},

		renderResult(result, _options, theme) {
			if (result.details?.success) {
				return new Text(theme.fg("success", "✓ ") + theme.fg("muted", "Tasks initialized"), 0, 0);
			}
			const text = result.content[0];
			const msg = text?.type === "text" ? text.text : "";
			return new Text(theme.fg("error", msg), 0, 0);
		},
	});

	// tasks_add - Add a new task
	pi.registerTool({
		name: "tasks_add",
		label: "Tasks Add",
		description: "Add a new task. Always provide a body to preserve context.",
		parameters: Type.Object({
			title: Type.String({ description: "Task title" }),
			body: Type.String({ description: "Task body (why, scope, acceptance criteria)" }),
			priority: Type.Optional(
				StringEnum([...PriorityValues] as const, { description: "Task priority (default: medium)" }),
			),
			tags: Type.Optional(Type.Array(Type.String()), { description: "Tags for the task" }),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const args = ["add", params.title, "--body", params.body, "--json"];

			if (params.priority) {
				args.push("--priority", params.priority);
			}

			if (params.tags && params.tags.length > 0) {
				args.push("--tags", params.tags.join(","));
			}

			const result = await pi.exec("tasks", args, { signal });
			const response = JSON.parse(result.stdout) as { task?: { id: string } };

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error adding task: ${result.stderr}` }],
					details: { success: false },
				};
			}

			const taskId = response.task?.id || "unknown";

			return {
				content: [
					{
						type: "text",
						text: `Added task #${taskId}: ${params.title}`,
					},
				],
				details: { id: taskId, title: params.title, success: true },
			};
		},

		renderCall(args, theme) {
			let text = theme.fg("toolTitle", theme.bold("tasks_add "));
			text += theme.fg("accent", `"${args.title}"`);
			if (args.priority) {
				text += " " + theme.fg("muted", `(${args.priority})`);
			}
			if (args.tags?.length) {
				text += " " + theme.fg("dim", args.tags.map((t: string) => `#${t}`).join(" "));
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, _options, theme) {
			if (result.details?.success) {
				return (
					new Text(
						theme.fg("success", "✓ ") +
							theme.fg("accent", `#${result.details.id}`) +
							" " +
							theme.fg("muted", result.details.title),
					)
				);
			}
			const text = result.content[0];
			const msg = text?.type === "text" ? text.text : "";
			return new Text(theme.fg("error", msg), 0, 0);
		},
	});

	// tasks_list - List tasks with optional filtering
	pi.registerTool({
		name: "tasks_list",
		label: "Tasks List",
		description: "List tasks. Filter by status, priority, or tags.",
		parameters: Type.Object({
			status: Type.Optional(StringEnum([...StatusValues] as const, { description: "Filter by status" })),
			priority: Type.Optional(
				StringEnum([...PriorityValues] as const, { description: "Filter by priority" }),
			),
			tags: Type.Optional(Type.Array(Type.String()), { description: "Filter by tags" }),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const args = ["list", "--json"];

			if (params.status) {
				args.push("--status", params.status);
			}

			if (params.priority) {
				args.push("--priority", params.priority);
			}

			if (params.tags && params.tags.length > 0) {
				args.push("--tags", params.tags.join(","));
			}

			const result = await pi.exec("tasks", args, { signal });

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error listing tasks: ${result.stderr}` }],
					details: { tasks: [], count: 0 },
				};
			}

			let tasks: TaskJson[] = [];
			try {
				const response = JSON.parse(result.stdout) as TasksListResponse;
				tasks = response.tasks || [];
			} catch {
				tasks = [];
			}

			let output = "";
			if (tasks.length === 0) {
				output = "No tasks found";
			} else {
				output = `Found ${tasks.length} task(s):\n\n`;
				for (const task of tasks) {
					const statusIcon = task.status === "done" ? "✓" : task.status === "in_progress" ? "→" : "○";
					const statusColor = task.status === "done" ? "success" : task.status === "in_progress" ? "accent" : "dim";
					const priorityColor =
						task.priority === "critical"
							? "error"
							: task.priority === "high"
								? "warning"
								: task.priority === "medium"
									? "muted"
									: "dim";
					output += `${statusIcon} #${task.id} [${task.priority}] ${task.title}\n`;
					if (task.body) {
						output += `    ${task.body}\n`;
					}
					if (task.tags.length > 0) {
						output += `    Tags: ${task.tags.join(", ")}\n`;
					}
					if (task.dependencies.length > 0) {
						output += `    Depends on: ${task.dependencies.join(", ")}\n`;
					}
					output += "\n";
				}
			}

			return {
				content: [{ type: "text", text: output }],
				details: { tasks, count: tasks.length },
			};
		},

		renderCall(args, theme) {
			let text = theme.fg("toolTitle", theme.bold("tasks_list"));
			const filters: string[] = [];
			if (args.status) filters.push(args.status);
			if (args.priority) filters.push(args.priority);
			if (args.tags?.length) filters.push(args.tags.join(","));
			if (filters.length) {
				text += " " + theme.fg("dim", `(${filters.join(", ")})`);
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, { expanded }, theme) {
			const details = result.details as { tasks: TaskJson[]; count: number } | undefined;
			if (!details) {
				const text = result.content[0];
				return new Text(text?.type === "text" ? text.text : "", 0, 0);
			}

			if (details.count === 0) {
				return new Text(theme.fg("dim", "No tasks"), 0, 0);
			}

			let text = theme.fg("muted", `${details.count} task(s)`);
			const display = expanded ? details.tasks : details.tasks.slice(0, 3);

			for (const task of display) {
				const statusIcon = task.status === "done" ? "✓" : task.status === "in_progress" ? "→" : "○";
				text += `\n${statusIcon} ${theme.fg("accent", `#${task.id}`)} ${theme.fg("muted", task.title)}`;
			}

			if (!expanded && details.count > 3) {
				text += `\n${theme.fg("dim", `... ${details.count - 3} more`)}`;
			}

			return new Text(text, 0, 0);
		},
	});

	// tasks_next - Show next ready tasks
	pi.registerTool({
		name: "tasks_next",
		label: "Tasks Next",
		description: "Show next ready tasks (not blocked by dependencies). Use --all to show all.",
		parameters: Type.Object({
			all: Type.Optional(Type.Boolean({ description: "Show all ready tasks" })),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const args = ["next", "--json"];
			if (params.all) {
				args.push("--all");
			}

			const result = await pi.exec("tasks", args, { signal });

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error: ${result.stderr}` }],
					details: { tasks: [] },
				};
			}

			const response = JSON.parse(result.stdout) as TasksListResponse;
			const tasks = response.tasks || [];

			let output = "";
			if (tasks.length === 0) {
				output = "No ready tasks";
			} else {
				output = `Ready tasks (${tasks.length}):\n\n`;
				for (const task of tasks) {
					const priorityColor =
						task.priority === "critical"
							? "error"
							: task.priority === "high"
								? "warning"
								: "muted";
					output += `#${task.id} [${task.priority}] ${task.title}\n`;
					if (task.body) {
						output += `    ${task.body}\n`;
					}
					if (task.tags.length > 0) {
						output += `    Tags: ${task.tags.join(", ")}\n`;
					}
					output += "\n";
				}
			}

			return {
				content: [{ type: "text", text: output }],
				details: { tasks, count: tasks.length },
			};
		},

		renderCall(_args, theme) {
			return new Text(theme.fg("toolTitle", theme.bold("tasks_next")), 0, 0);
		},

		renderResult(result, { expanded }, theme) {
			const details = result.details as { tasks: TaskJson[]; count: number } | undefined;
			if (!details) {
				const text = result.content[0];
				return new Text(text?.type === "text" ? text.text : "", 0, 0);
			}

			if (details.count === 0) {
				return new Text(theme.fg("dim", "No ready tasks"), 0, 0);
			}

			let text = theme.fg("success", `✓ ${details.count} ready`);
			const display = expanded ? details.tasks : details.tasks.slice(0, 3);

			for (const task of display) {
				text += `\n  ${theme.fg("accent", `#${task.id}`)} ${theme.fg("muted", task.title)}`;
			}

			if (!expanded && details.count > 3) {
				text += `\n  ${theme.fg("dim", `... ${details.count - 3} more`)}`;
			}

			return new Text(text, 0, 0);
		},
	});

	// tasks_done - Mark a task as done
	pi.registerTool({
		name: "tasks_done",
		label: "Tasks Done",
		description: "Mark a task as done by ID",
		parameters: Type.Object({
			id: Type.String({ description: "Task ID to mark as done" }),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const result = await pi.exec("tasks", ["done", params.id, "--json"], { signal });

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error: ${result.stderr}` }],
					details: { success: false, id: params.id },
				};
			}

			return {
				content: [{ type: "text", text: `Marked task #${params.id} as done` }],
				details: { success: true, id: params.id },
			};
		},

		renderCall(args, theme) {
			return new Text(theme.fg("toolTitle", theme.bold("tasks_done ")) + theme.fg("accent", `#${args.id}`), 0, 0);
		},

		renderResult(result, _options, theme) {
			if (result.details?.success) {
				return new Text(theme.fg("success", "✓ ") + theme.fg("muted", `Task #${result.details.id} done`), 0, 0);
			}
			const text = result.content[0];
			const msg = text?.type === "text" ? text.text : "";
			return new Text(theme.fg("error", msg), 0, 0);
		},
	});

	// tasks_edit - Edit a task
	pi.registerTool({
		name: "tasks_edit",
		label: "Tasks Edit",
		description: "Edit a task. Can change status, priority, tags, or body",
		parameters: Type.Object({
			id: Type.String({ description: "Task ID to edit" }),
			status: Type.Optional(StringEnum([...StatusValues] as const, { description: "New status" })),
			priority: Type.Optional(
				StringEnum([...PriorityValues] as const, { description: "New priority" }),
			),
			tags: Type.Optional(Type.Array(Type.String()), { description: "Set tags (replaces existing)" }),
			body: Type.Optional(Type.String({ description: "New task body" })),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const args = ["edit", params.id, "--json"];

			if (params.status) {
				args.push("--status", params.status);
			}

			if (params.priority) {
				args.push("--priority", params.priority);
			}

			if (params.tags && params.tags.length > 0) {
				args.push("--tags", params.tags.join(","));
			}

			if (params.body) {
				args.push("--body", params.body);
			}

			const result = await pi.exec("tasks", args, { signal });

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error: ${result.stderr}` }],
					details: { success: false, id: params.id },
				};
			}

			const changes: string[] = [];
			if (params.status) changes.push(`status → ${params.status}`);
			if (params.priority) changes.push(`priority → ${params.priority}`);
			if (params.tags) changes.push(`tags → ${params.tags.join(", ")}`);
			if (params.body) changes.push("body updated");

			return {
				content: [
					{
						type: "text",
						text: `Updated task #${params.id}: ${changes.join(", ")}`,
					},
				],
				details: { success: true, id: params.id, changes },
			};
		},

		renderCall(args, theme) {
			let text = theme.fg("toolTitle", theme.bold("tasks_edit ")) + theme.fg("accent", `#${args.id}`);
			const parts: string[] = [];
			if (args.status) parts.push(args.status);
			if (args.priority) parts.push(args.priority);
			if (args.tags?.length) parts.push(args.tags.join(","));
			if (args.body) parts.push("body");
			if (parts.length) {
				text += " " + theme.fg("dim", `(${parts.join(", ")})`);
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, _options, theme) {
			if (result.details?.success) {
				return new Text(theme.fg("success", "✓ ") + theme.fg("muted", `Task #${result.details.id} updated`), 0, 0);
			}
			const text = result.content[0];
			const msg = text?.type === "text" ? text.text : "";
			return new Text(theme.fg("error", msg), 0, 0);
		},
	});

	// tasks_delete - Delete a task
	pi.registerTool({
		name: "tasks_delete",
		label: "Tasks Delete",
		description: "Delete a task by ID",
		parameters: Type.Object({
			id: Type.String({ description: "Task ID to delete" }),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const result = await pi.exec("tasks", ["delete", params.id, "--json"], { signal });

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error: ${result.stderr}` }],
					details: { success: false, id: params.id },
				};
			}

			return {
				content: [{ type: "text", text: `Deleted task #${params.id}` }],
				details: { success: true, id: params.id },
			};
		},

		renderCall(args, theme) {
			return new Text(
				theme.fg("toolTitle", theme.bold("tasks_delete ")) + theme.fg("accent", `#${args.id}`),
				0,
				0,
			);
		},

		renderResult(result, _options, theme) {
			if (result.details?.success) {
				return new Text(theme.fg("warning", "✗ ") + theme.fg("muted", `Deleted #${result.details.id}`), 0, 0);
			}
			const text = result.content[0];
			const msg = text?.type === "text" ? text.text : "";
			return new Text(theme.fg("error", msg), 0, 0);
		},
	});

	// tasks_link - Create dependency link between tasks
	pi.registerTool({
		name: "tasks_link",
		label: "Tasks Link",
		description: "Create a dependency link. Child task is blocked by parent task.",
		parameters: Type.Object({
			childId: Type.String({ description: "Child task ID (the one being blocked)" }),
			parentId: Type.String({ description: "Parent task ID (the blocker)" }),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const result = await pi.exec(
				"tasks",
				["link", params.childId, params.parentId, "--json"],
				{ signal },
			);

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error: ${result.stderr}` }],
					details: { success: false, childId: params.childId, parentId: params.parentId },
				};
			}

			return {
				content: [
					{
						type: "text",
						text: `Linked: task #${params.childId} is now blocked by task #${params.parentId}`,
					},
				],
				details: { success: true, childId: params.childId, parentId: params.parentId },
			};
		},

		renderCall(args, theme) {
			return (
				new Text(
					theme.fg("toolTitle", theme.bold("tasks_link ")) +
						theme.fg("accent", `#${args.childId}`) +
						" " +
						theme.fg("dim", "←") +
						" " +
						theme.fg("accent", `#${args.parentId}`),
				)
			);
		},

		renderResult(result, _options, theme) {
			if (result.details?.success) {
				return new Text(
					theme.fg("success", "✓ ") +
						theme.fg("muted", `#${result.details.childId}`) +
						" " +
						theme.fg("dim", "←") +
						" " +
						theme.fg("muted", `#${result.details.parentId}`),
				);
			}
			const text = result.content[0];
			const msg = text?.type === "text" ? text.text : "";
			return new Text(theme.fg("error", msg), 0, 0);
		},
	});

	// tasks_tag - Add a tag to a task
	pi.registerTool({
		name: "tasks_tag",
		label: "Tasks Tag",
		description: "Add a tag to an existing task",
		parameters: Type.Object({
			id: Type.String({ description: "Task ID" }),
			tag: Type.String({ description: "Tag to add" }),
		}),

		async execute(_toolCallId, params, _onUpdate, _ctx, signal) {
			const result = await pi.exec("tasks", ["tag", params.id, params.tag, "--json"], {
				signal,
			});

			if (result.code !== 0) {
				return {
					content: [{ type: "text", text: `Error: ${result.stderr}` }],
					details: { success: false, id: params.id, tag: params.tag },
				};
			}

			return {
				content: [{ type: "text", text: `Added tag "${params.tag}" to task #${params.id}` }],
				details: { success: true, id: params.id, tag: params.tag },
			};
		},

		renderCall(args, theme) {
			return (
				new Text(
					theme.fg("toolTitle", theme.bold("tasks_tag ")) +
						theme.fg("accent", `#${args.id}`) +
						" " +
						theme.fg("dim", "+") +
						" " +
						theme.fg("accent", `#${args.tag}`),
				)
			);
		},

		renderResult(result, _options, theme) {
			if (result.details?.success) {
				return new Text(
					theme.fg("success", "✓ ") +
						theme.fg("muted", `#${result.details.id}`) +
						" " +
						theme.fg("dim", "+") +
						" " +
						theme.fg("accent", result.details.tag),
				);
			}
			const text = result.content[0];
			const msg = text?.type === "text" ? text.text : "";
			return new Text(theme.fg("error", msg), 0, 0);
		},
	});

	// Register /tasks command for users
	pi.registerCommand("tasks", {
		description: "Show tasks for the current project",
		handler: async (_args, ctx) => {
			if (!ctx.hasUI) {
				ctx.ui.notify("/tasks requires interactive mode", "error");
				return;
			}

			// Get all tasks
			const result = await pi.exec("tasks", ["list", "--json"]);
			if (result.code !== 0) {
				ctx.ui.notify("Error listing tasks - run tasks_init first", "error");
				return;
			}

			const response = JSON.parse(result.stdout) as TasksListResponse;
			const tasks = response.tasks || [];

			await ctx.ui.custom<void>((_tui, theme, _kb, done) => {
				class TasksComponent {
					private lines: string[];
					private cachedWidth?: number;
					private cachedLines?: string[];

					constructor() {
						this.lines = this.renderLines();
					}

					private renderLines(): string[] {
						const lines: string[] = [];

						lines.push("");
						lines.push(theme.fg("accent", " Tasks ") + theme.fg("borderMuted", "─".repeat(50)));
						lines.push("");

						if (tasks.length === 0) {
							lines.push(`  ${theme.fg("dim", "No tasks yet. Ask the agent to add some!")}`);
						} else {
							const todo = tasks.filter((t) => t.status === "todo").length;
							const inProgress = tasks.filter((t) => t.status === "in_progress").length;
							const done = tasks.filter((t) => t.status === "done").length;

							lines.push(`  ${theme.fg("dim", "Status:")} ${todo} todo, ${inProgress} in progress, ${done} done`);
							lines.push("");

							for (const task of tasks) {
								const statusIcon =
									task.status === "done" ? theme.fg("success", "✓") :
									task.status === "in_progress" ? theme.fg("accent", "→") :
									theme.fg("dim", "○");
								const priorityBadge =
									task.priority === "critical" ? theme.fg("error", `[${task.priority}]`) :
									task.priority === "high" ? theme.fg("warning", `[${task.priority}]`) :
									theme.fg("dim", `[${task.priority}]`);
								lines.push(`  ${statusIcon} ${theme.fg("accent", `#${task.id}`)} ${priorityBadge} ${task.title}`);
								if (task.body) {
									lines.push(`    ${theme.fg("dim", task.body)}`);
								}
								if (task.tags.length > 0) {
									lines.push(`    ${theme.fg("dim", "Tags:")} ${task.tags.map((t) => theme.fg("accent", `#${t}`)).join(" ")}`);
								}
								if (task.dependencies.length > 0) {
									lines.push(`    ${theme.fg("dim", "Depends on:")} ${task.dependencies.map((id) => theme.fg("accent", id)).join(", ")}`);
								}
								lines.push("");
							}
						}

						lines.push(`  ${theme.fg("dim", "Press Escape to close")}`);
						lines.push("");

						return lines;
					}

					handleInput(data: string): void {
						if (data === "escape" || data === "ctrl+c") {
							done();
						}
					}

					render(width: number): string[] {
						if (this.cachedLines && this.cachedWidth === width) {
							return this.cachedLines;
						}
						this.cachedWidth = width;
						this.cachedLines = this.lines.map((line) => line.substring(0, width));
						return this.cachedLines;
					}

					invalidate(): void {
						this.cachedWidth = undefined;
						this.cachedLines = undefined;
					}
				}

				return new TasksComponent();
			});
		},
	});
}
