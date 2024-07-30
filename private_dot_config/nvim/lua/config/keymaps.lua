vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { silent = true })

vim.keymap.set("n", "<esc>", function()
	vim.cmd.noh()
	vim.snippet.stop()
end)

vim.keymap.set("i", "<c-u>", "<nop>", { silent = true })

vim.keymap.set("n", "gh", "^", { desc = "Goto beginging of line", silent = true })
vim.keymap.set("n", "gl", "$", { desc = "Goto end of line", silent = true })
