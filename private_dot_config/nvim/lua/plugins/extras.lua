return {
	{ "leoluz/nvim-dap-go", enabled = false },
	{ "nvim-neotest/neotest-go", enabled = false },
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	opts = {
	-- 		servers = {
	-- 			eslint = {
	-- 				settings = {
	-- 					format = false,
	-- 					run = "onType",
	-- 					workingDirectory = { mode = "location" },
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
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
	{
		"garymjr/native_snippets_extended",
		dev = true,
		event = "InsertEnter",
		opts = {},
		config = function()
			require("native_snippets_extended").setup()
			require("native_snippets_extended.cmp").register()
		end,
	},
	{
		"nvim-cmp",
		opts = function(_, opts)
			local source = require("cmp").config.sources({
				{ name = "native_snippets" },
			})[1]
			table.insert(opts.sources, 2, source)
			return opts
		end,
	},
}
