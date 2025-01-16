return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("snacks").setup(opts)

			require("config.keymaps")
			require("config.autocmds")
		end,
	},
}
