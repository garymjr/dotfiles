MiniDeps.add({
  source = "zbirenbaum/copilot.lua",
  hooks = {
    post_checkout = function() vim.cmd("Copilot auth") end,
  },
})

MiniDeps.later(function()
  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-y>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },

    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  })
end)
