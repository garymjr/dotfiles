return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "dockerfile" } },
	},
	{
		"mason.nvim",
		optional = true,
		opts = { ensure_installed = { "hadolint" } },
	},
	{
		"nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				dockerfile = { "hadolint" },
			},
		},
	},
	{
		"nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				dockerls = {},
				docker_compose_language_service = {},
			},
		},
	},
}
