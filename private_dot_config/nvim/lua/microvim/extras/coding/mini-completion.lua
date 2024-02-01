return {
	{ "hrsh7th/nvim-cmp", enabled = false },
	{
		"nvimdev/epo.nvim",
		event = "InsertEnter",
		opts = {
			signature = true,
			kind_format = function(k)
				return k:lower()
			end,
		},
		init = function()
			vim.opt.completeopt = "menu,menuone,popup,noselect"
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.capabilities = require("epo").register_cap()
			return opts
		end,
	},
}
