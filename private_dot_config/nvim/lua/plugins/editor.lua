local Util = require("lazyvim.util")

return {
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
	{ "nvim-pack/nvim-spectre", enabled = false },
	{ "folke/flash.nvim", enabled = false },
	{ "RRethy/vim-illuminate", enabled = false },
	{ "folke/todo-comments.nvim", enabled = false },
	{
		"gitsigns.nvim",
		opts = {
			current_line_blame = true,
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", enabled = false },
	{
		"natecraddock/telescope-zf-native.nvim",
		config = function()
			Util.on_load("telescope.nvim", function()
				require("telescope").load_extension("zf-native")
			end)
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = function(_, opts)
			local extensions = opts.extensions or {}
			extensions["zf-native"] = {
				file = {
					enable = true,
					highlight_results = true,
					match_filename = true,
				},
				generic = {
					enable = true,
					highlight_results = true,
					match_filename = false,
				},
			}
		end,
	},
}
