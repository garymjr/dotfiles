MiniDeps.add("f-person/git-blame.nvim")

MiniDeps.later(function()
  require("gitblame").setup({
    enable = true,
    message_template = "   <author>, <date> ",
    date_format = "%%r",
    virtual_text_column = 1,
  })
  vim.g.gitblame_message_when_not_committed = ""
end)
