return {
	{
		"L3MON4D3/LuaSnip",
		enabled = false,
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
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			}
			opts.sources = cmp.config.sources({
				{
					name = "copilot",
					group_index = 1,
					priority = 100,
				},
				{ name = "nvim_lsp" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			})
			return opts
		end,
	},
	{
		"saadparwaiz1/cmp_luasnip",
		enabled = false,
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
