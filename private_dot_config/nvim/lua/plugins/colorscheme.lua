return {
	{ "tokyonight.nvim", enabled = false },
	{ "catppuccin", enabled = false },
	{
		"rebelot/kanagawa.nvim",
		opts = {
			keywordStyle = { italic = false },
		},
	},
	{
		"savq/melange-nvim",
		config = false,
	},
	{
		"LazyVim",
		opts = {
			colorscheme = "melange",
		},
	},
	{
		"lazy.nvim",
		opts = { install = { colorscheme = { "melange" } } },
	},
}
