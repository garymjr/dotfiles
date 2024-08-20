MiniDeps.later(function()
  require("mini.bufremove").setup()

  vim.keymap.set("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, true)
  end, { desc = "[B]uffer [D]elete" })
end)
