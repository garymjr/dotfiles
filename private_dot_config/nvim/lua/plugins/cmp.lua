MiniDeps.add({
	source = "iguanacucumber/magazine.nvim",
  name = "nvim-cmp",
	depends = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"onsails/lspkind.nvim",
	},
})

local MAX_ABBR_WIDTH = 30
local MAX_MENU_WIDTH = 30

MiniDeps.later(function()
	local cmp = require("cmp")
	cmp.setup({
		mapping = {
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
		},
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},
		matching = {
			disallow_fuzzy_matching = false,
			disallow_fullfuzzy_matching = false,
			disallow_partial_fuzzy_matching = false,
			disallow_partial_matching = false,
			disallow_prefix_unmatching = false,
		},
		sources = cmp.config.sources({
			-- { name = "copilot" },
			{ name = "nvim_lsp" },
			{ name = "path" },
		}, {
			{ name = "buffer" },
		}),
		view = {
			entries = {
				follow_cursor = true,
			},
		},
		formatting = {
			format = function(_, item)
				if vim.api.nvim_strwidth(item.abbr) > MAX_ABBR_WIDTH then
					item.abbr = vim.fn.strcharpart(item.abbr, 0, MAX_ABBR_WIDTH) .. "…"
				end

				if vim.api.nvim_strwidth(item.menu or "") > MAX_MENU_WIDTH then
					item.menu = vim.fn.strcharpart(item.menu, 0, MAX_MENU_WIDTH) .. "…"
				end

				return item
			end,
		},
	})
end)
