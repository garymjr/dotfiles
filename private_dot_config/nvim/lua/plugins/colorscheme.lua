return {
	{ "tokyonight.nvim", enabled = false },
	{ "catppuccin", enabled = false },
	{
		"rebelot/kanagawa.nvim",
		enabled = false,
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
	{
		"ribru17/bamboo.nvim",
		dependencies = {
			{
				"LazyVim",
				opts = {
					colorscheme = "bamboo",
				},
			},
			{
				"lazy.nvim",
				opts = { install = { colorscheme = { "bamboo" } } },
			},
		},
		opts = {
			code_style = {
				conditionals = { italic = false },
				namespaces = { italic = false },
			},
			lualine = {
				transparent = true,
			},
		},
	},
}
