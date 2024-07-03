return {
	{ "mini.pairs", enabled = false },
	{ "nvim-cmp", enabled = false },
  {
    "echasnovski/mini.completion",
    event = "VeryLazy",
    opts = {
      lsp_completion = {
        auto_setup = false,
      },
    },
  },
	-- {
	-- 	"nvim-cmp",
	-- 	opts = function(_, opts)
	-- 		local cmp = require("cmp")
	-- 		opts.mapping["<CR>"] = function(fallback)
	-- 			cmp.abort()
	-- 			fallback()
	-- 		end
	-- 		opts.mapping["<S-CR>"] = function(fallback)
	-- 			cmp.abort()
	-- 			fallback()
	-- 		end
	-- 		opts.mapping["<C-y>"] = LazyVim.cmp.confirm()
	-- 	end,
	-- },
	-- {
	-- 	"nvim-snippets",
	-- 	opts = {
	-- 		extended_filetypes = {
	-- 			typescript = { "javascript", "javascriptreact" },
	-- 			typescriptreact = { "javascript", "javascriptreact" },
	-- 		},
	-- 	},
	-- },
}
