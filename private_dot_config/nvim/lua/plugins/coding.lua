return {
	{
		"L3MON4D3/LuaSnip",
		opts = {
			history = true,
			region_check_events = "InsertEnter",
			delete_check_events = "TextChanged,InsertLeave",
		},
		config = function(_, opts)
			require("luasnip").setup(opts)
			require("luasnip").filetype_extend("typescript", {
				"typescriptreact",
			})
		end,
	},
	{
		"rafamadriz/friendly-snippets",
		enabled = true,
	},
	{ "echasnovski/mini.pairs", enabled = false },
	{ "JoosepAlviste/nvim-ts-context-commentstring", enabled = false },
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.options.custom_commentstring = nil
			return opts
		end,
	},
}
