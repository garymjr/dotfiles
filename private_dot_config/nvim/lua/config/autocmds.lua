local group = vim.api.nvim_create_augroup("vim_enter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "qf",
    command = [[wincmd J]],
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        require("vim.highlight").on_yank({ timeout=100 })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    command = [[setlocal nonumber norelativenumber]],
})
