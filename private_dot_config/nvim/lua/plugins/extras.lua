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
}
