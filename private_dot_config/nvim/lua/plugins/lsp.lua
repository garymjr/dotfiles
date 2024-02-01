return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				virtual_text = {
					severity = vim.diagnostic.severity.ERROR,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = require("lazyvim.config").icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = require("lazyvim.config").icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = require("lazyvim.config").icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = require("lazyvim.config").icons.diagnostics.Info,
					},
				},
			},
			inlay_hints = {
				enabled = false,
			},
			servers = {
				tsserver = {
					init_options = {
						tsserver = {
							path = os.getenv("NVM_BIN") .. "/bin/tsserver",
						},
						preferences = {
							includeInlayParameterNameHints = "literals",
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
							importModuleSpecifierPreference = "non-relative",
						},
					},
				},
			},
		},
	},
	{ "folke/neoconf.nvim", enabled = false },
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			window = {
				blend = 0,
			},
		},
	},
}
