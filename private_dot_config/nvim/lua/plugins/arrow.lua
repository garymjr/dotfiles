MiniDeps.add("otavioschwanck/arrow.nvim")

MiniDeps.later(function()
  require("arrow").setup({
    show_icons = true,
    leader_key = ",",
  })
end)
