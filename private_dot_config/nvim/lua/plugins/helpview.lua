require("mini.deps").add({
  source = "OXY2DEV/helpview.nvim",
  depends = {
    "nvim-treesitter/nvim-treesitter",
  },
})

require("mini.deps").later(function()
  require("helpview").setup()
end)
