-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
	vim.api.nvim_create_augroup("gwm_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("neogit"),
	pattern = {
		"NeogitStatus",
	},
	callback = function()
		vim.cmd("wincmd J")
	end,
})
