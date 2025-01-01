return {
  {
    "github/copilot.vim",
    event = "VeryLazy",
    version = false,
    keys = {
      {
        "<C-l>",
        "<Plug>(copilot-next)",
        mode = "i",
        silent = true,
        desc = "Next suggestion",
      },
      {
        "<C-h>",
        "<Plug>(copilot-previous)",
        mode = "i",
        silent = true,
        desc = "Previous suggestion",
      },
      {
        "<C-d>",
        "<Plug>(copilot-dismiss)",
        mode = "i",
        silent = true,
        desc = "Dismiss suggestion",
      },
    },
    config = function()
      vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
      }
    end,
  },
}
