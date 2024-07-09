return {
	{ "bufferline.nvim", enabled = false },
	{ "noice.nvim", enabled = false },
	{
		"nvim-notify",
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.notify = function(msg, ...)
				if msg == "No information available" then
					return
				end
				require("notify")(msg, ...)
			end
		end,
	},
	{ "indent-blankline.nvim", enabled = false },
	-- { "lualine.nvim", enabled = false },
	-- {
	-- 	"echasnovski/mini.statusline",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- },
}
