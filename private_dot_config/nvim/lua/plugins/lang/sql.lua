local sql_ft = { "sql", "mysql", "plsql" }

return {
	{
		"tpope/vim-dadbod",
		cmd = "DB",
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = "vim-dadbod",
		ft = sql_ft,
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		dependencies = "vim-dadbod",
		keys = {
			{ "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
		},
		init = function()
			local data_path = vim.fn.stdpath("data")

			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
			vim.g.db_ui_show_database_icon = true
			vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
			vim.g.db_ui_use_nerd_fonts = true
			vim.g.db_ui_use_nvim_notify = true
			vim.g.db_ui_execute_on_save = false
		end,
	},
	{
		"nvim-treesitter",
		optional = true,
		opts = { ensure_installed = { "sql" } },
	},
	{
		"blink.cmp",
		optional = true,
		opts = {
			sources = {
				default = { "dadbod" },
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
		},
		dependencies = {
			"kristijanhusak/vim-dadbod-completion",
		},
	},
	{
		"mason.nvim",
		optional = true,
		opts = { ensure_installed = { "sqlfluff" } },
	},
	{
		"nvim-lint",
		optional = true,
		opts = function(_, opts)
			for _, ft in ipairs(sql_ft) do
				opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
				table.insert(opts.linters_by_ft[ft], "sqlfluff")
			end
		end,
	},
	{
		"conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters.sqlfluff = {
				args = { "format", "--dialect=ansi", "-" },
			}
			for _, ft in ipairs(sql_ft) do
				opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
				table.insert(opts.formatters_by_ft[ft], "sqlfluff")
			end
		end,
	},
}
