MiniDeps.add("lewis6991/gitsigns.nvim")

MiniDeps.later(function()
  require("gitsigns").setup()

  local gs = package.loaded.gitsigns
  vim.keymap.set("n", "<leader>hp", function() gs.preview_hunk() end, { silent = true, desc = "Preview hunk" })
  vim.keymap.set(
    "n",
    "<leader>hb",
    function() gs.blame_line({ full = true }) end,
    {
      silent = true,
      desc = "Blame line",
    }
  )
  vim.keymap.set(
    "n",
    "<leader>tb",
    function() gs.toggle_current_line_blame() end,
    { silent = true, desc = "Toggle blame line" })
end)
