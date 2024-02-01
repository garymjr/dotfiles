return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] =
				{ "gd", "<cmd>Pick lsp scope='definition'<cr>", desc = "Goto Definition", has = "definition" }
			keys[#keys + 1] = { "gr", "<cmd>Pick lsp scope='references'<cr>", desc = "References" }
			keys[#keys + 1] = { "gI", "<cmd>Pick lsp scope='implementation'<cr>", desc = "Goto Implementation" }
			keys[#keys + 1] = { "gy", "<cmd>Pick lsp scope='type_definition'<cr>", desc = "Goto T[y]pe Definition" }
		end,
	},
}
