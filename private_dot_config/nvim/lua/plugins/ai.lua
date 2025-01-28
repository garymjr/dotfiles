local H = {}

function H.prompt()
	if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
		vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
			if input then
				vim.cmd("'<,'>CodeCompanion " .. input)
			end
		end)
	else
		vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
			if input then
				vim.cmd("CodeCompanion " .. input)
			end
		end)
	end
end

---@type snacks.picker.finder
function H.pick_prompt()
	local result = require("CopilotChat.actions").prompt_actions()

	local items = {}

	if not result then
		return items
	end

	for label, action in pairs(result.actions) do
		table.insert(items, {
			text = label,
			prompt = action.prompt,
		})
	end

	return items
end

return {
	{
		"github/copilot.vim",
		lazy = false,
		build = ":Copilot auth",
		keys = {
			{
				"<C-;>",
				[[copilot#Accept("\\<CR>")]],
				mode = "i",
				silent = true,
				desc = "Accept suggestion",
				expr = true,
				replace_keycodes = false,
			},
			{
				"<C-l>",
				"<Plug>(copilot-next)",
				mode = "i",
				silent = true,
				desc = "Next suggestion",
			},
			{
				"<C-h>",
				"<Plug>(copilot-previous)",
				mode = "i",
				silent = true,
				desc = "Previous suggestion",
			},
			{
				"<C-d>",
				"<Plug>(copilot-dismiss)",
				mode = "i",
				silent = true,
				desc = "Dismiss suggestion",
			},
			{
				"<C-s>",
				"<Plug>(copilot-suggest)",
				mode = "i",
				silent = true,
				desc = "Trigger suggestion",
			},
		},
		config = function()
			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{
				"markview.nvim",
				ft = function(_, ft)
					return vim.list_extend(ft, { "copilot-chat" })
				end,
				init = function()
					vim.api.nvim_create_autocmd("FileType", {
						pattern = "copilot-chat",
						command = "Markview attach",
					})
				end,
			},
		},
		cmd = "CopilotChat",
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				auto_insert_mode = false,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				model = "gpt-4o-2024-08-06",
				prompts = {
					Commit = {
						model = "gpt-4o-mini",
						selection = false,
					},
				},
				mappings = {
					complete = {
						insert = "<c-y>",
					},
					reset = {
						normal = "gx",
						insert = "",
					},
					accept_diff = {
						normal = "ga",
						insert = "<C-a>",
					},
				},
				window = {
					width = 0.4,
				},
			}
		end,
		keys = {
			{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ap",
				function()
					Snacks.picker.copilot_chat()
				end,
				desc = "Prompt Actions (CopilotChat)",
				mode = { "n", "v" },
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)
		end,
	},
	{
		"snacks.nvim",
		opts = {
			picker = {
				sources = {
					copilot_chat = {
						finder = H.pick_prompt,
						format = "text",
						preview = function(ctx)
							local buf = ctx.preview:scratch()
							ctx.preview:set_title(ctx.item.text)
							vim.bo[buf].filetype = "markdown"
							vim.bo[buf].modifiable = true
							local lines = vim.split(ctx.item.prompt, "\n")
							vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
							vim.bo[buf].modifiable = false
						end,
						confirm = function(picker, item)
							picker:close()

							if not item then
								return
							end

							require("CopilotChat").ask(
								item.prompt,
								require("CopilotChat.actions").prompt_actions()[item.text]
							)
						end,
					},
				},
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			{
				"blink.cmp",
				opts = {
					sources = {
						default = { "codecompanion" },
						providers = {
							codecompanion = {
								name = "CodeCompanion",
								module = "codecompanion.providers.completion.blink",
							},
						},
					},
				},
			},
			{
				"markview.nvim",
				ft = function(_, ft)
					return vim.list_extend(ft, { "codecompanion" })
				end,
				init = function()
					vim.api.nvim_create_autocmd("FileType", {
						pattern = "codecompanion",
						command = "Markview attach",
					})
				end,
			},
		},
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{ "<leader>aa", "<cmd>CodeCompanionChat toggle<cr>", desc = "Toggle (CodeCompanion)", mode = { "n", "v" } },
			{
				"<leader>ap",
				"<cmd>CodeCompanionActions<cr>",
				desc = "Promp Actions (CodeCompanion)",
				mode = { "n", "v" },
			},
			{ "<leader>aq", H.prompt, desc = "Prompt (CodeCompanion)", mode = { "n", "v" } },
		},
		opts = {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gpt-4o-2024-08-06",
							},
						},
					})
				end,
				copilot_mini = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gpt-4o-mini",
							},
						},
					})
				end,
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = "cmd:security find-generic-password -a aistudio.google.com -s gemini-api-key -w",
						},
						schema = {
							model = {
								default = "gemini-2.0-flash-exp",
							},
						},
					})
				end,
			},
			display = {
				diff = {
					provider = "mini_diff",
				},
			},
			strategies = {
				chat = {
					adapter = "gemini",
					keymaps = {
						close = {
							modes = {
								n = "q",
							},
							index = 4,
							callback = "keymaps.close",
							description = "Close Chat",
						},
						stop = {
							modes = {
								n = "<c-c>",
								i = "<c-c>",
							},
							index = 5,
							callback = "keymaps.stop",
							description = "Stop Request",
						},
					},
				},
				inline = {
					adapter = "copilot",
				},
			},
			prompt_library = {
				["Generate a Commit Message"] = {
					opts = {
						adapter = {
							name = "copilot",
							model = "gpt-4o-mini",
						},
						contains_code = true,
					},
					prompts = {
						{
							role = "user",
							content = function()
								return string.format(
									[[You are an expert at following the Commitizen Commit specification. Do not simply list the changs, instead always try to infer intent. When referring to code use '`' for a single line and '```' for multi line code blocks. Only respond with the commit message. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```
]],
									vim.fn.system("git diff --no-ext-diff --staged")
								)
							end,
						},
					},
				},
			},
		},
	},
	{ "CopilotChat.nvim", enabled = false },
}
