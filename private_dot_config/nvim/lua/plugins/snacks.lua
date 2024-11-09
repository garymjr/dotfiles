MiniDeps.add({ source = "folke/snacks.nvim" })

MiniDeps.now(function()
  require("snacks").setup()
end)
