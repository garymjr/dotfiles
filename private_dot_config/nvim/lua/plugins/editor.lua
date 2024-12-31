return {
  { "neo-tree.nvim", enabled = false },
  { "grug-far.nvim", enabled = false },
  { "flash.nvim", enabled = false },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "<leader>fe", "<cmd>Oil " .. LazyVim.root() .. "<cr>", desc = "Explore (Root Dir)" },
      { "<leader>fE", "<cmd>Oil " .. vim.uv.cwd() .. "<cr>", desc = "Explore (cwd)" },
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory", silent = true },
    },
    opts = {
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      },
    },
  },
}
