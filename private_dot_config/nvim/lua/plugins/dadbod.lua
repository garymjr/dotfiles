MiniDeps.add({
	source = "kristijanhusak/vim-dadbod-ui",
	depends = {
		"tpope/vim-dadbod",
	},
})

MiniDeps.later(function()
	vim.g.db_ui_auto_execute_table_helpers = 1
	vim.g.db_ui_show_database_icon = true
	vim.g.db_ui_use_nerd_fonts = true
	vim.g.db_ui_execute_on_save = false

	vim.keymap.set("n", "<leader>D", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI", silent = true })
end)
