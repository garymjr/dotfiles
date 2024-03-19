MiniDeps.add({
  source = "folke/todo-comments.nvim",
  depends = { "nvim-lua/plenary.nvim" },
})

MiniDeps.later(function()
  require("todo-comments").setup({
    signs = false,
  })
end)
