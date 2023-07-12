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

vim.api.nvim_create_autocmd("WinLeave", {
    group = group,
    callback = function()
        if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "i", true)
        end
    end,
})
