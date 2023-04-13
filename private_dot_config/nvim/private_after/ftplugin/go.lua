vim.opt_local.expandtab = false

local group = vim.api.nvim_create_augroup("lsp_format", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
	pattern = "*.go",
    callback = function()
		vim.lsp.buf.format()
	end,
})
