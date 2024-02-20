return {
	{
		"j-hui/fidget.nvim",
		event = "BufAdd",
		opts = {
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
	},
	{
		"catppuccin",
		opts = function(_, opts)
			opts.integrations.fidget = true
			return opts
		end,
	},
}
