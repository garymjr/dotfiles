local config = require("config")

MiniDeps.add({
	source = "neovim/nvim-lspconfig",
	depends = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/lazydev.nvim",
		"Bilal2453/luvit-meta",
		"b0o/SchemaStore.nvim",
	},
})

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = config.icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = config.icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = config.icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = config.icons.diagnostics.Info,
		},
	},
})

MiniDeps.later(function()
	require("lazydev").setup({
		library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	})
end)

MiniDeps.later(function()
	require("mason").setup()

	local mr = require("mason-registry")
	mr.refresh(function()
		for _, tool in ipairs(config.tools) do
			local p = mr.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end
	end)
end)

MiniDeps.later(function()
	local capabilities =
		vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), config.capabilities or {})

	local ensure_installed = vim.tbl_keys(config.servers)

	require("mason-lspconfig").setup({
		ensure_installed = ensure_installed,
		handlers = {
			function(server_name)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, config.servers[server_name] or {})

				require("lspconfig")[server_name].setup(server_opts)
			end,
		},
	})
end)
