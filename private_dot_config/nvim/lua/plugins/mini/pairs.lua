require("mini.deps").later(function()
  require("mini.pairs").setup {
    modes = { insert = true, command = true, terminal = false },
  }
end)
