return {
	{
		"numToStr/Navigator.nvim",
		keys = {
			{
				"<C-h>",
				function()
					require("Navigator").left()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
			{
				"<C-j>",
				function()
					require("Navigator").down()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
			{
				"<C-k>",
				function()
					require("Navigator").up()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
			{
				"<C-l>",
				function()
					require("Navigator").right()
				end,
				mode = { "n", "i", "v" },
				silent = true,
			},
		},
		opts = {},
	},
}
