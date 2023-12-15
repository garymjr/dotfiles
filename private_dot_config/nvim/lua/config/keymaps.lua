-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			map(m, lhs, rhs, opts)
		end
	end

	local options = { noremap = true, silent = true }
	if opts then
		opts = vim.tbl_extend("force", options, opts)
	end

	vim.keymap.set(mode, lhs, rhs, opts)
end

-- map("n", "<leader>fc", "<cmd>e $MYVIMRC<cr>", { desc = "Edit config" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
-- map({ "i", "s" }, "<Tab>", function()
-- 	if vim.snippet.jumpable(1) then
-- 		vim.snippet.jump(1)
-- 	end
-- end)
--
-- map({ "i", "s" }, "<S-Tab>", function()
-- 	if vim.snippet.jumpable(-1) then
-- 		vim.snippet.jump(-1)
-- 	end
-- end)

map("n", "[c", function()
	require("treesitter-context").go_to_context()
end, { silent = true, desc = "Previous context" })

vim.keymap.del({ "n", "i", "v" }, "<A-j>")
vim.keymap.del({ "n", "i", "v" }, "<A-k>")
