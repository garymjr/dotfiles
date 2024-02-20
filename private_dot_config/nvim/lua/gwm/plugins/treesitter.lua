return {
	{
		"nvim-treesitter-context",
		opts = {
			max_lines = 1,
			on_attach = function(bufnr)
				vim.keymap.set("n", "[c", function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end, { silent = true, buffer = bufnr })
			end,
		},
	},
}
