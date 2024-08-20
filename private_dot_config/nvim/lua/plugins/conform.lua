local config = require("config")

MiniDeps.add({
	source = "stevearc/conform.nvim",
	depends = {
		"williamboman/mason.nvim",
	},
})

MiniDeps.later(function()
	require("conform").setup({
		default_format_opts = {
			timeout_ms = 3000,
			async = false,
			quiet = false,
			lsp_format = "fallback",
		},
    formatters = config.formatters,
		formatters_by_ft = config.formatters_by_ft,
	})

	vim.keymap.set("n", "<leader>cf", function()
		require("conform").format({ bufnr = 0 })
	end, { desc = "[C]ode [F]ormat" })
end)
