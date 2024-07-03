return {
	{ "mini.pairs", enabled = false },
	{
		"nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.mapping["<CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end
			opts.mapping["<S-CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end
			opts.mapping["<C-y>"] = LazyVim.cmp.confirm()
		end,
	},
	{ "nvim-snippets", enabled = false },
}
