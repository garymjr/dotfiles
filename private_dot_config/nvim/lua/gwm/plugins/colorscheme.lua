return {
	{ "tokyonight.nvim", enabled = false },
	{
		"catppuccin",
		opts = function(_, opts)
			opts.integrations.fidget = true
			opts.custom_highlights = function(colors)
				local U = require("catppuccin.utils.colors")
				return {
					PmenuKind = { fg = colors.green, bg = U.darken(colors.surface0, 0.8, colors.rust) },
					PmenuKindSel = { fg = colors.blue, bg = C.surface1, style = { "bold" } },
					MiniPickPrompt = { fg = colors.text },
				}
			end
			return opts
		end,
	},
	{
		"LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
