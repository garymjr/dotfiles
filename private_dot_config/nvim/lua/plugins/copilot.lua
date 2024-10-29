MiniDeps.add({ source = "zbirenbaum/copilot.lua" })

MiniDeps.later(function()
	require("copilot").setup({
		suggestion = { enabled = false },
		panel = { enabled = false },
	})
end)

MiniDeps.add({ source = "zbirenbaum/copilot-cmp" })

MiniDeps.later(function()
	require("copilot_cmp").setup()
end)

MiniDeps.add({ source = "CopilotC-Nvim/CopilotChat.nvim", checkout = "canary" })

MiniDeps.later(function()
	require("CopilotChat").setup({
		question_header = " User ",
		answer_header = " Copilot ",
		error_header = " Error ",
	})
end)
