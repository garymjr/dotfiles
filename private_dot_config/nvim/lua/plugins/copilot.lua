MiniDeps.add({
  source = "garymjr/copilot.lua",
  depends = { "zbirenbaum/copilot-cmp" },
  hooks = {
    post_checkout = function() vim.cmd("Copilot auth") end,
  },
})


MiniDeps.later(function()
  require("copilot").setup({
    suggestion = { enabled = true, auto_trigger = true },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  })
end)
