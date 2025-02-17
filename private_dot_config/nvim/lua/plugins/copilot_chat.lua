local H = {}

---@param kind string
function H.pick(kind)
	return function()
		local actions = require("CopilotChat.actions")
		local items = actions[kind .. "_actions"]()
		if not items then
			return
		end
		return require("CopilotChat.integrations.snacks").pick(items)
	end
end

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"copilot.vim",
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
		cmd = function()
			local commands = {
				"Open",
				"Close",
				"Toggle",
				"Stop",
				"Reset",
				"Save",
				"Load",
				"DebugInfo",
				"Models",
				"Agents",
			}

			local cmds = {}
			for _, cmd in ipairs(commands) do
				table.insert(cmds, "CopilotChat" .. cmd)
			end
			return cmds
		end,
		keys = {
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
			{ "<leader>ap", H.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
		},
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				auto_insert_mode = false,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				model = "gemini-2.0-flash-001",
				prompts = {
					Commit = {
						selection = false,
					},
				},
				mappings = {
					complete = {
						insert = "<c-y>",
					},
					reset = {
						normal = "",
						insert = "",
					},
					accept_diff = {
						normal = "ga",
						insert = "<C-a>",
					},
				},
			}
		end,
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
}
