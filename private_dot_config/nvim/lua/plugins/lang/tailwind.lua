return {
	{
		"nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				tailwindcss = {
					settings = {
						tailwindCSS = {
							includeLanguages = {
								elixir = "html-eex",
								eelixir = "html-eex",
								heex = "html-eex",
							},
						},
					},
				},
			},
		},
	},
}
