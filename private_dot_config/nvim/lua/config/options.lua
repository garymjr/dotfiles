vim.g.autoformat = false
vim.g.trouble_lualine = false

local opt = vim.opt

opt.cursorline = false
opt.list = false
opt.swapfile = false
opt.timeoutlen = 300

vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})

vim.treesitter.language.register("markdown", "mdx")

-- don't override treesitter hightlights
vim.highlight.priorities.semantic_tokens = 95
