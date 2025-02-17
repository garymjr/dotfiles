return {
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("snacks").setup(opts)

			require("config.keymaps")
			require("config.autocmds")

			-- Override vim.notify to use snacks.nvim
			-- This is a workaround for filtering out some messages that are not useful
			vim.schedule(function()
				---@diagnostic disable-next-line: duplicate-set-field
				vim.notify = function(msg, level, o)
					if msg == "No information available" then
						return
					end

					return Snacks.notifier.notify(msg, level, o)
				end
			end)
		end,
	},
}
