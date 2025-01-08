return {
  { "mini.pairs",   enabled = false },
  { "lazydev.nvim", vscode = true },
  {
    "blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
    },
  },
  {
    "blink.cmp",
    opts = function(_, opts)
      opts.keymap = {
        preset = "enter",
      }
    end,
  },
}
