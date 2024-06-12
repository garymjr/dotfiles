return {
	{
		"nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = vim.tbl_deep_extend("force", {}, opts.ensure_installed, {
        "diff",
				"eex",
				"elixir",
				"graphql",
				"heex",
				"sql",
			})

			opts.textobjects.move = {
				goto_next_start = { ["]f"] = "@function.outer" },
				goto_next_end = { ["]F"] = "@function.outer" },
				goto_previous_start = { ["[f"] = "@function.outer" },
				goto_previous_end = { ["[F"] = "@function.outer" },
			}
		end,
	},
}
