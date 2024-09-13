MiniDeps.add("sindrets/diffview.nvim")
MiniDeps.later(function()
  require("diffview").setup()
end)
