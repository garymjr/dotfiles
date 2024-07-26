return {
	{
		"nvim-lspconfig",
		opts = function(_, opts)
			opts.document_highlight = {
				enabled = false,
			}

			opts.inlay_hints = {
				enabled = false,
			}

			opts.servers.cssls = {}
			opts.servers.tailwindcss = {
				init_options = {
					userLanguages = {
						elixir = "html-eex",
						eelixir = "html-eex",
						heex = "html-eex",
					},
				},
			}
		end,
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
