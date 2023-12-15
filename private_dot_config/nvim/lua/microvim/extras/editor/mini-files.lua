return {
	require("lazyvim.plugins.extras.editor.mini-files"),
	{
		"echasnovski/mini.files",
		opts = {
			options = {
				use_as_default_explorer = true,
			},
			windows = {
				preview = false,
			},
		},
		keys = {
			{
				"-",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
			},
		},
	},
}
