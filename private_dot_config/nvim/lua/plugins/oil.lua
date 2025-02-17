return {
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		keys = {
			{ "-", "<cmd>Oil<cr>" },
		},
		opts = {
			keymaps = {
				["q"] = { "actions.close", mode = "n" },
			},
		},
	},
}
