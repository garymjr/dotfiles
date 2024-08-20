MiniDeps.add({
  source = "OXY2DEV/helpview.nvim",
  depends = {
    "nvim-treesitter/nvim-treesitter",
  },
})

MiniDeps.later(function()
  require("helpview").setup()
end)
