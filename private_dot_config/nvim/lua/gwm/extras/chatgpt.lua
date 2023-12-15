return {
	{
		"jackMort/ChatGPT.nvim",
		enabled = false,
		keys = {
			{
				"<leader>ac",
				function()
					require("chatgpt").openChat()
				end,
				silent = true,
				desc = "Open ChatGPT",
			},
			{
				"<leader>ae",
				function()
					require("chatgpt").edit_with_instructions()
				end,
				silent = true,
				desc = "Edit with instructions",
				mode = "v",
			},
		},
		opts = {},
	},
	{
		"dpayne/CodeGPT.nvim",
		enabled = false,
		cmd = { "Chat" },
		keys = {
			{
				"<leader>ad",
				"<cmd>Chat doc<cr>",
				silent = true,
				desc = "Document selection",
				mode = "v",
			},
			{
				"<leader>ac",
				"<cmd>Chat<cr>",
				desc = "Complete selection",
				mode = "v",
			},
			{
				"<leader>ae",
				"<cmd>Chat explain<cr>",
				desc = "Explain selection",
				mode = "v",
			},
			{
				"<leader>ac",
				function()
					vim.ui.input({ "Enter message:" }, function(input)
						vim.cmd("Chat " .. input)
					end)
				end,
				desc = "Ask question",
				mode = "n",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("codegpt.config")
		end,
	},
	{
		"folke/which-key.nvim",
		opts = {
			defaults = {
				["<leader>a"] = { name = "+ai" },
			},
		},
	},
}
