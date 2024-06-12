return {
	{
		"nvim-lspconfig",
		opts = {
			document_highlight = {
				enabled = false,
			},
			inlay_hints = {
				enabled = false,
			},
			servers = {
				tailwindcss = {
					init_options = {
						userLanguages = {
							elixir = "html-eex",
							eelixir = "html-eex",
							heex = "html-eex",
						},
					},
				},
			},
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lspconfig" },
		opts = {},
	},
}
