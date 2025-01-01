local opt = vim.opt

vim.g.keymaps_lsp_ignore_ft = vim.list_extend(vim.g.keymaps_lsp_ignore_ft or {}, { "codecompanion" })

opt.cursorline = false
opt.list = false
opt.messagesopt = { "history:500", "wait:0" }
opt.swapfile = false

vim.filetype.add({
  extension = {
    ex = "elixir",
  },
})
