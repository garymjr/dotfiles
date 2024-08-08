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
			local actions = require("telescope.actions.layout")
			opts.defaults.mappings.i["<c-o>"] = actions.toggle_preview
		end,
	},
	{
		"otavioschwanck/arrow.nvim",
		keys = {
			{
				"<tab>",
				function()
					require("arrow.commands").commands.open()
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
		"sindrets/diffview.nvim",
		keys = {
			{ "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview", silent = true },
		},
		opts = {},
	},
	{
		"julienvincent/hunk.nvim",
		cmd = "DiffEditor",
		opts = {},
	},
	{ "grug-far.nvim", enabled = false },
	{ "gitsigns.nvim", enabled = false },
}
