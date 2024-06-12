return {
	{ "neo-tree.nvim", enabled = false },
	{ "nvim-spectre", enabled = false },
	{ "flash.nvim", enabled = false },
	{
		"telescope.nvim",
		opts = function(_, opts)
			local actions = require("telescope.actions.layout")
			opts.defaults.mappings.i["<c-o>"] = actions.toggle_preview
		end,
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		keys = {
			{
				"<leader>fm",
				function()
					require("oil").open(LazyVim.root())
				end,
				desc = "Open Oil (Root dir)",
			},
			{
				"<leader>fM",
				"<cmd>Oil<cr>",
				desc = "Open Oil (cwd)",
				silent = true,
			},
			{
				"-",
				"<leader>fM",
				silent = true,
				remap = true,
			},
		},
		opts = {
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = "actions.select_vsplit",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
				["q"] = "actions.close",
			},
		},
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
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
		},
		keys = {
			{ "<leader>ux", "<cmd>DBUIToggle<cr>", desc = "DadBod", silent = true },
		},
		config = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
}
