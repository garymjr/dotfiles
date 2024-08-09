return {
	{
		"nvim-cmp",
		enabled = false,
		opts = function(_, opts)
			opts.mapping["<CR>"] = LazyVim.cmp.confirm()
		end,
	},
	{
		"nvim-snippets",
		enabled = false,
		opts = {
			extended_filetypes = {
				typescript = { "javascript", "javascriptreact", "jsdoc" },
				typescriptreact = { "javascript", "javascriptreact", "jsdoc" },
			},
		},
	},
}
