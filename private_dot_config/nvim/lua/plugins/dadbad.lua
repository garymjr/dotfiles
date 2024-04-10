MiniDeps.add("tpope/vim-dadbod")

MiniDeps.add("kristijanhusak/vim-dadbod-ui")

MiniDeps.later(function()
  vim.g.db_ui_use_nerd_fonts = 1
  vim.keymap.set("n", "<leader>td", "<cmd>DBUIToggle<cr>", { silent = true, desc = "Toggle DB UI" })
end)
