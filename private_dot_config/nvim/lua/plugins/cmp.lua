MiniDeps.add({
	source = "yioneko/nvim-cmp",
	checkout = "perf",
	depends = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"onsails/lspkind.nvim",
	},
})

MiniDeps.later(function()
	local cmp = require("cmp")
	cmp.setup({
		mapping = {
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
		},
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},
		matching = {
			disallow_fuzzy_matching = false,
			disallow_fullfuzzy_matching = false,
			disallow_partial_fuzzy_matching = false,
			disallow_partial_matching = false,
			disallow_prefix_unmatching = false,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "path" },
		}, {
			{ name = "buffer" },
		}),
		view = {
			entries = {
				follow_cursor = true,
			},
		},
	})
end)
