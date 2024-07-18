return {
	{ "neo-tree.nvim", enabled = false },
	{ "nvim-spectre", enabled = false },
	{ "flash.nvim", enabled = false },
	{
		"telescope.nvim",
		keys = {
			{ "<leader>fc", "<cmd>Telescope chezmoi find_files<cr>", desc = "Find Config File", silent = true },
		},
		opts = function(_, opts)
			local actions = require "telescope.actions.layout"
			opts.defaults.mappings.i["<c-o>"] = actions.toggle_preview
		end,
	},
	{
		"otavioschwanck/arrow.nvim",
		keys = {
			{
				",",
				function()
					require("arrow.commands").commands.open()
				end,
			},
			{
				"m",
				function()
					require("arrow.buffer_ui").openMenu(vim.api.nvim_get_current_buf())
				end,
			},
		},
		opts = {
			show_icons = true,
			leader_key = ",",
			buffer_leader_key = "m",
		},
	},
	{
		"numToStr/Navigator.nvim",
		keys = {
			{ "<c-h>", "<cmd>NavigatorLeft<cr>", silent = true, mode = { "n", "t" } },
			{ "<c-j>", "<cmd>NavigatorDown<cr>", silent = true, mode = { "n", "t" } },
			{ "<c-k>", "<cmd>NavigatorUp<cr>", silent = true, mode = { "n", "t" } },
			{ "<c-l>", "<cmd>NavigatorRight<cr>", silent = true, mode = { "n", "t" } },
		},
		opts = {},
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		keys = {
			{ "<leader>ux", "<cmd>DBUIToggle<cr>", desc = "DadBod", silent = true },
		},
	},
	{
		"sindrets/diffview.nvim",
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview", silent = true },
		},
		opts = {},
	},
}
