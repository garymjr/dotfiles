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
				keymaps = {
					regenerate = {
						modes = {
							n = "gR",
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
end)
