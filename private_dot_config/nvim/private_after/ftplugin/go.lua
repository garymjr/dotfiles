vim.opt_local.expandtab = false

_G["formatters"] = _G["formatters"] or {}
_G["formatters"].goimports = function()
    vim.lsp.buf.format()
end

vim.opt_local.formatexpr = "v:lua.formatters.goimports()"

local group = vim.api.nvim_create_augroup("lsp_format", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
	pattern = "*.go",
    callback = function()
        vim.lsp.buf.format()
	end,
})
