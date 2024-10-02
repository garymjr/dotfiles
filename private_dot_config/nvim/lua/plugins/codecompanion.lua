MiniDeps.add({
	source = "olimorris/codecompanion.nvim",
	depends = {
		"nvim-lua/plenary.nvim",
	},
})

MiniDeps.later(function()
	require("codecompanion").setup({
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

	vim.keymap.set("n", "<leader>ct", "<cmd>CodeCompanionChat<cr>", { silent = true })
	vim.keymap.set("n", "<leader>cm", "<cmd>CodeCompanionActions<cr>", { silent = true })

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
end)
