MiniDeps.add({
	source = "olimorris/codecompanion.nvim",
	depends = {
		"nvim-lua/plenary.nvim",
	},
})

MiniDeps.later(function()
	require("codecompanion").setup({
		adapters = {
			ollama = require("codecompanion.adapters").extend(
				"ollama",
				{ schema = { model = { default = "codegemma" } } }
			),
		},
		strategies = {
			chat = {
				adapter = "copilot",
				slash_commands = {
					file = {
						opts = {
							provider = "mini_pick",
						},
					},
					help = {
						opts = {
							provider = "mini_pick",
						},
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
			agent = {
				adapter = "copilot",
			},
		},
	})

	vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { silent = true })
	vim.keymap.set("n", "<leader>am", "<cmd>CodeCompanionActions<cr>", { silent = true })

	local function inline_prompt()
		local mode = vim.fn.mode()
		if mode == "v" or mode == "V" then
			vim.ui.input({ prompt = "Inline Prompt: " }, function(input)
				if input then
					vim.cmd(string.format("'<,'>CodeCompanion %s", input))
				end
			end)
		else
			vim.ui.input({ prompt = "Inline Prompt: " }, function(input)
				if input then
					vim.cmd("CodeCompanion " .. input)
				end
			end)
		end
	end

	vim.keymap.set({ "n", "v" }, "<c-cr>", inline_prompt)
	vim.keymap.set({ "n", "v" }, "<leader>ai", inline_prompt)
end)
