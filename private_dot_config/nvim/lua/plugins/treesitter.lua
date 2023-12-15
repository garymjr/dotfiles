return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		keys = {
			{
				"[c",
				function()
					require("treesitter-context").go_to_context()
				end,
				silent = true,
				desc = "Previous context",
			},
		},
		opts = {
			max_lines = 1,
		},
	},
}
