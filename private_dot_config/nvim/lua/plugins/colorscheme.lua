return {
	{ "tokyonight.nvim", enabled = false },
	{ "catppuccin", enabled = false },
	{
		"rebelot/kanagawa.nvim",
		dependencies = {
			{
				"LazyVim",
				opts = {
					colorscheme = "kanagawa",
				},
			},
			{
				"lazy.nvim",
				opts = { install = { colorscheme = { "kanagawa" } } },
			},
		},
		opts = {
			keywordStyle = { italic = false },
		},
	},
}
