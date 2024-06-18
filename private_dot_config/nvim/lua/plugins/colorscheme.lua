return {
	{ "tokyonight.nvim", enabled = false },
	{ "catppuccin", enabled = false },
	{
		"rebelot/kanagawa.nvim",
		opts = {
			keywordStyle = { italic = false },
			overrides = function(colors)
				return {
					LineNr = { bg = colors.palette.sumiInk3 },
					GitSignsAdd = { bg = colors.palette.sumiInk3 },
					GitSignsChange = { bg = colors.palette.sumiInk3 },
					GitSignsDelete = { bg = colors.palette.sumiInk3 },
				}
			end,
		},
	},
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
}
