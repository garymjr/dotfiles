return {
	{
		"mbbill/undotree",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<leader>tu", "<cmd>UndotreeToggle<cr>", { silent = true, desc = "Toggle undotree" })
		end,
	},
	{
		"folke/which-key.nvim",
		opts = {
			defaults = {
				["<leader>t"] = { name = "+toggle" },
			},
		},
	},
}
