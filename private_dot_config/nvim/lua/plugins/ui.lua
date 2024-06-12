return {
	{ "bufferline.nvim", enabled = false },
	{ "noice.nvim", enabled = false },
	{
		"dashboard-nvim",
		opts = function(_, opts)
			opts.config.header = vim.split(string.rep("\n", 15), "\n")
		end,
	},
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
}
