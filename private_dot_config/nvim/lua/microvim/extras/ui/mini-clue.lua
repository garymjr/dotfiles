return {
	{ "folke/which-key.nvim", enabled = false },
	{
		"echasnovski/mini.clue",
		event = { "VeryLazy", "LazyFile" },
		opts = function()
			local miniclue = require("mini.clue")

			return {
				triggers = {
					{ mode = "n", keys = "<leader>" },
					{ mode = "x", keys = "<leader>" },

					-- `g` key
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },

					-- Marks
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },

					-- Registers
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },

					-- Window commands
					{ mode = "n", keys = "<C-w>" },

					-- `z` key
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
				},

				clues = {
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
					{ mode = "n", keys = "<leader>b", desc = "+buffer" },
					{ mode = "n", keys = "<leader>c", desc = "+code" },
					{ mode = "n", keys = "<leader>f", desc = "+file/find" },
					{ mode = "n", keys = "<leader>g", desc = "+git" },
					{ mode = "n", keys = "<leader>gh", desc = "+hunks" },
					{ mode = "n", keys = "<leader>q", desc = "+quit/session" },
					{ mode = "n", keys = "<leader>s", desc = "+search" },
					{ mode = "n", keys = "<leader>u", desc = "+ui" },
					{ mode = "n", keys = "<leader>w", desc = "+windows" },
					{ mode = "n", keys = "<leader>x", desc = "+diagnostics/quickfix" },
				},
				window = {
					config = { width = "auto" },
				},
			}
		end,
	},
}
