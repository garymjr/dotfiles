return {
	"stevearc/oil.nvim",
	keys = {
		{
			"<leader>fm",
			function()
				require("oil").open()
			end,
			desc = "Open directory (cwd)",
		},
		{
			"<leader>fM",
			function()
				require("oil").open(require("lazyvim.util.root").get())
			end,
			desc = "Open directory (root dir)",
		},
	},
	opts = {
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["R"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["g."] = "actions.toggle_hidden",
			["q"] = "actions.close",
		},
		use_default_keymaps = false,
	},
}
