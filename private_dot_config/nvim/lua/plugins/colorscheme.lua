return {
	{ "folke/tokyonight.nvim", enabled = false },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = function(_, opts)
			opts.integrations.fidget = true
			opts.integrations.neogit = true
			opts.custom_highlights = function(colors)
				return {
					MiniPickPrompt = { fg = colors.text },
				}
			end
			return opts
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
