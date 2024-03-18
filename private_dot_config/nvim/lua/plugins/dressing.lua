MiniDeps.add("stevearc/dressing.nvim")

MiniDeps.later(function()
  require("dressing").setup()
end)
