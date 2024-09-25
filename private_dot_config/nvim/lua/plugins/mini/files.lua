MiniDeps.later(function()
  require("mini.files").setup {
    windows = {
      preview = false,
      width_nofocus = 25,
      width_focus = 50,
      max_number = 3,
    },
    options = {
      use_as_default_explorer = true,
    },
  }

  vim.keymap.set("n", "<leader>fm", function()
    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
  end, { desc = "[F]ile [M]anager" })

  vim.keymap.set("n", "<leader>fM", function()
    require("mini.files").open(vim.uv.cwd(), true)
  end, { desc = "[F]ile [M]anager (cwd)" })
end)
