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
	{
		"LazyVim",
		opts = {
			colorscheme = "habamax",
		},
	},
	{
		"lazy.nvim",
		opts = { install = { colorscheme = { "habamax" } } },
	},
  {
    "echasnovski/mini.hues",
    lazy = false,
    opts = {
      background = "#1e1e2e",
      foreground = "#cdd6f4",
    },
  },
}
