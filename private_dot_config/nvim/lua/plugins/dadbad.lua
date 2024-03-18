MiniDeps.add("tpope/vim-dadbod")

MiniDeps.add("kristijanhusak/vim-dadbod-ui")

MiniDeps.later(function()
  vim.g.db_ui_use_nerd_fonts = 1
end)
