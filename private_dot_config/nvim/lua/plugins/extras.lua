return {
	{
		"leoluz/nvim-dap-go",
		enabled = false,
	},
	{
		"nvim-neotest/neotest-go",
		enabled = false,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				eslint = {
					settings = {
						format = false,
						run = "onType",
						workingDirectory = { mode = "location" },
					},
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"sql",
				"comment",
				"dockerfile",
				"proto",
			})
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		opts = {
			show_hidden = true,
		},
	},
	{
		"garymjr/nvim-snippets",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			create_cmp_source = true,
			extended_filetypes = {
				typescript = { "javascript" },
				typescriptreact = { "javascript", "javascriptreact" },
			},
		},
		keys = {
			{
				"<Tab>",
				function()
					if vim.snippet.jumpable(1) then
						vim.schedule(function()
							vim.snippet.jump(1)
						end)
						return
					end
					return "<Tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<Tab>",
				function()
					vim.schedule(function()
						vim.snippet.jump(1)
					end)
				end,
				expr = true,
				silent = true,
				mode = "s",
			},
			{
				"<S-Tab>",
				function()
					if vim.snippet.jumpable(-1) then
						vim.schedule(function()
							vim.snippet.jump(-1)
						end)
						return
					end
					return "<S-Tab>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = cmp.config.sources({
				{
					name = "copilot",
					group_index = 1,
					priority = 100,
				},
				{ name = "snippets" },
				{ name = "nvim_lsp" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			})
			return opts
		end,
	},
	{
		"numToStr/Navigator.nvim",
		keys = {
			{
				"<C-h>",
				function()
					require("Navigator").left()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
			{
				"<C-j>",
				function()
					require("Navigator").down()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
			{
				"<C-k>",
				function()
					require("Navigator").up()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
			{
				"<C-l>",
				function()
					require("Navigator").right()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
		},
		opts = {},
	},
}
