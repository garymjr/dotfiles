return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", { desc = "Open parent directory" } },
    },
    opts = {
      keymaps = {
        q = { "actions.close", mode = "n" },
      },
    },
  },
}
