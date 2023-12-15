return {
	"stevearc/oil.nvim",
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Open parent directory",
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
