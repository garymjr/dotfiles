return {
	{ "mini.pairs", enabled = false },
	{
		"nvim-cmp",
		opts = function(_, opts)
			opts.mapping["<CR>"] = LazyVim.cmp.confirm()
		end,
	},
	{
		"nvim-snippets",
		opts = {
			extended_filetypes = {
				typescript = { "javascript", "javascriptreact", "jsdoc" },
				typescriptreact = { "javascript", "javascriptreact", "jsdoc" },
			},
		},
	},
}
