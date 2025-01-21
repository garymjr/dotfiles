return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "dockerfile" } },
	},
	{
		"mason.nvim",
		opts = { ensure_installed = { "hadolint" } },
	},
	{
		"nvim-lint",
		opts = {
			linters_by_ft = {
				dockerfile = { "hadolint" },
			},
		},
	},
	{
		"nvim-lspconfig",
		opts = {
			servers = {
				dockerls = {},
				docker_compose_language_service = {},
			},
		},
	},
}
