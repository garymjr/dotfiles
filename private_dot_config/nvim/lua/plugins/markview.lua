MiniDeps.add({
	source = "OXY2DEV/markview.nvim",
	depends = {
		"nvim-treesitter/nvim-treesitter",
	},
})

MiniDeps.later(function()
	require("markview").setup({
		modes = { "n", "no", "c" },
		hybrid_modes = { "n" },
		callbacks = {
			on_enabled = function()
				vim.opt_local.conceallevel = 2
				vim.opt_local.concealcursor = "c"
			end,
		},
	})
end)
