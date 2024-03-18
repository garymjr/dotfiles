MiniDeps.add("sindrets/diffview.nvim")

MiniDeps.later(function()
  require("diffview").setup({
    view = {
      gq = "<cmd>DiffviewClose<cr>",
    },
  })

  vim.keymap.set("n", "<leader>gs", "<cmd>DiffviewOpen<cr>", { noremap = true, silent = true })
end)
