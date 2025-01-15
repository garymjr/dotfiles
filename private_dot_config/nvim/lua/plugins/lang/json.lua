return {
	{
		"nvim-treesitter",
		optional = true,
		opts = { ensure_installed = { "json5" } },
	},
	{ "b0o/SchemaStore.nvim" },
	{
		"nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
			},
		},
	},
}
