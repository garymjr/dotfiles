return {
	{
		"ThePrimeagen/harpoon",
		keys = function()
			return {
				{
					"<leader>ha",
					function()
						require("harpoon.mark").add_file()
					end,
					silent = true,
					desc = "Add mark",
				},
				{
					"<leader>h1",
					function()
						require("harpoon.ui").nav_file(1)
					end,
					silent = true,
					desc = "Goto mark 1",
				},
				{
					"<leader>h2",
					function()
						require("harpoon.ui").nav_file(2)
					end,
					silent = true,
					desc = "Goto mark 2",
				},
				{
					"<leader>h3",
					function()
						require("harpoon.ui").nav_file(3)
					end,
					silent = true,
					desc = "Goto mark 3",
				},
				{
					"<leader>hm",
					function()
						require("harpoon.ui").toggle_quick_menu()
					end,
					silent = true,
					desc = "Toggle quick menu",
				},
				{
					"<leader>hp",
					function()
						require("harpoon.ui").nav_prev()
					end,
					silent = true,
					desc = "Goto previous mark",
				},
				{
					"<leader>hn",
					function()
						require("harpoon.ui").nav_next()
					end,
					silent = true,
					desc = "Goto next mark",
				},
			}
		end,
		opts = {
			global_settings = {
				tmux_autoclose_windows = true,
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			defaults = {
				["<leader>h"] = { name = "+harpoon" },
			},
		},
	},
}
