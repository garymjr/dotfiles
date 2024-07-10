return {
	{ "tokyonight.nvim", enabled = false },
	{ "catppuccin", enabled = false },
	{
		"rebelot/kanagawa.nvim",
		enabled = false,
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
	{ "echasnovski/mini.hues", lazy = false },
	{
		"LazyVim",
		opts = {
			colorscheme = "minidawn",
		},
	},
	{
		"lazy.nvim",
		opts = { install = { colorscheme = { "minidawn" } } },
	},
}
