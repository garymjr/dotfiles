MiniDeps.add("brianaung/compl.nvim")
MiniDeps.later(function()
  require("compl").setup()
end)
