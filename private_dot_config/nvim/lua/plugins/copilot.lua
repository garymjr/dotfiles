return {
	{
		"github/copilot.vim",
		lazy = false,
		build = ":Copilot auth",
		keys = {
			{
				"<C-;>",
				[[copilot#Accept("\\<CR>")]],
				mode = "i",
				silent = true,
				desc = "Accept suggestion",
				expr = true,
				replace_keycodes = false,
			},
			{
				"<C-l>",
				"<Plug>(copilot-next)",
				mode = "i",
				silent = true,
				desc = "Next suggestion",
			},
			{
				"<C-h>",
				"<Plug>(copilot-previous)",
				mode = "i",
				silent = true,
				desc = "Previous suggestion",
			},
			{
				"<C-d>",
				"<Plug>(copilot-dismiss)",
				mode = "i",
				silent = true,
				desc = "Dismiss suggestion",
			},
			{
				"<C-s>",
				"<Plug>(copilot-suggest)",
				mode = "i",
				silent = true,
				desc = "Trigger suggestion",
			},
		},
		config = function()
			vim.g.copilot_no_tab_map = true
		end,
	},
}
