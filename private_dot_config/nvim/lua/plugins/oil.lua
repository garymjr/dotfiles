MiniDeps.add("stevearc/oil.nvim")

MiniDeps.later(function()
  require("oil").setup()
  vim.keymap.set("n", "-", "<cmd>Oil<cr>", { silent = true })
  vim.keymap.set("n", "<leader>fm", "<cmd>Oil<cr>", { silent = true, desc = "Explore" })
  vim.keymap.set(
    "n",
    "<leader>fM",
    function()
      require("oil").get_current_dir()
    end,
    {
      silent = true,
      desc = "Explore (cwd)",
    }
  )

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("gwm_oil", { clear = true }),
    pattern = "oil",
    callback = function(args)
      vim.keymap.set("n", "q", require("oil").close, { silent = true, buffer = args.buf })
    end,
  })
end)
