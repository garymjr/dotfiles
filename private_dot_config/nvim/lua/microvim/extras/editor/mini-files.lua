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
				window_focus = "auto",
			},
			mappings = {
				go_in_plus = "<CR>",
			},
		},
	},
}
