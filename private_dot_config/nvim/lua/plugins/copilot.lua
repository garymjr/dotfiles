MiniDeps.add({ source = "github/copilot.vim" })

MiniDeps.later(function()
	vim.g.copilot_assume_mapped = true
	vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
	vim.keymap.set("i", "<C-i>", "<Plug>(copilot-accept-line)", { silent = true })

	vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)", { silent = true })
	vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)", { silent = true })
	vim.keymap.set("i", "<C-l>", "<Plug>(copilot-suggest)", { silent = true })

	-- Set <C-d> to dismiss suggestion
	vim.keymap.set("i", "<C-d>", "<Plug>(copilot-dismiss)", { silent = true })
end)

MiniDeps.add({ source = "CopilotC-Nvim/CopilotChat.nvim", checkout = "canary" })

MiniDeps.later(function()
	require("CopilotChat").setup({
		question_header = " User ",
		answer_header = " Copilot ",
		error_header = " Error ",
		model = "claude-3.5-sonnet",
	})
end)
