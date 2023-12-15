return {
	{
		"echasnovski/mini.visits",
		event = { "VeryLazy", "LazyFile" },
		opts = {},
		keys = function()
			local sort_latest = require("mini.visits").gen_sort.default({ recency_weight = 1 })

			return {
				{
					"[{",
					function()
						require("mini.visits").iterate_paths("last", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit last",
				},
				{
					"[[",
					function()
						require("mini.visits").iterate_paths("forward", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit previous",
				},
				{
					"]]",
					function()
						require("mini.visits").iterate_paths("backward", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit next",
				},
				{
					"]}",
					function()
						require("mini.visits").iterate_paths("first", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit first",
				},
				{
					"<C-o>",
					function()
						require("mini.visits").iterate_paths(
							"forward",
							vim.fn.getcwd(),
							{ sort = sort_latest, wrap = true }
						)
					end,
				},
				{
					"<C-i>",
					function()
						require("mini.visits").iterate_paths(
							"backward",
							vim.fn.getcwd(),
							{ sort = sort_latest, wrap = true }
						)
					end,
				},
			}
		end,
	},
}
