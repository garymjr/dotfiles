return {
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format()
				end,
				mode = { "n", "v" },
				desc = "Format",
			},
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		opts = {
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				return {
					timeout_ms = 3000,
					async = false,
					quiet = false,
					lsp_format = "fallback",
				}
			end,
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
			},
		},
	},
}
