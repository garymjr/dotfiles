MiniDeps.add("numToStr/Navigator.nvim")

MiniDeps.later(function()
  require("Navigator").setup()

  vim.keymap.set({ "n", "t" }, "<c-h>", "<cmd>NavigatorLeft<cr>")
  vim.keymap.set({ "n", "t" }, "<c-l>", "<cmd>NavigatorRight<cr>")
  vim.keymap.set({ "n", "t" }, "<c-k>", "<cmd>NavigatorUp<cr>")
  vim.keymap.set({ "n", "t" }, "<c-j>", "<cmd>NavigatorDown<cr>")
end)
