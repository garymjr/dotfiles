return {
  { "mini.pairs", enabled = false },
  {
    "blink.cmp",
    opts = {
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        ghost_text = {
          enabled = false,
        },
        list = {
          selection = "manual",
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
