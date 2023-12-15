-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.cursorline = false
opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor"
opt.list = false
opt.swapfile = false
-- opt.statuscolumn = ""

-- vim.filetype.add({
-- 	extension = {
-- 		mdx = "markdown.mdx",
-- 		graphql = "graphql",
-- 	},
-- })
--
-- vim.treesitter.language.register("markdown.mdx", "mdx")
