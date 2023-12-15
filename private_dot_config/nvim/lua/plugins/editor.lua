return {
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
	{ "nvim-pack/nvim-spectre", enabled = false },
	{ "folke/flash.nvim", enabled = false },
	{ "RRethy/vim-illuminate", enabled = false },
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				layout_stratgey = "flex",
			},
			pickers = {
				buffers = {
					ignore_current_buffer = true,
				},
				find_files = {
					hidden = true,
				},
				git_files = {
					hidden = true,
				},
			},
		},
		keys = {
			{ "<leader>gs", vim.NIL },
		},
	},
	{ "folke/todo-comments.nvim", enabled = false },
}
