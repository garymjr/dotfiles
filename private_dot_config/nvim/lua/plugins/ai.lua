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

return {
	{
		"github/copilot.vim",
		event = "VeryLazy",
		version = false,
		keys = {
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
				"<C-;>",
				"<Plug>(copilot-suggest)",
				mode = "i",
				silent = true,
				desc = "Trigger suggestion",
			},
		},
		config = function() end,
	},
	{
		"olimorris/codecompanion.nvim",
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
								default = "claude-3.5-sonnet",
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
					adapter = "copilot",
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
		},
	},
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
		"render-markdown.nvim",
		optional = true,
		ft = function(_, ft)
			return vim.list_extend(ft, { "codecompanion" })
		end,
	},
	{
		"markview.nvim",
		optional = true,
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
}
