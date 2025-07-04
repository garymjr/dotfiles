return {
  {
    "Saghen/blink.cmp",
    enabled = false,
    version = "*",
    event = "InsertEnter",
    opts_extend = { "sources.default" },
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        list = {
          selection = {
            preselect = false,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = false,
        },
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = true,
          },
        },
        keymap = {
          ["<tab>"] = { "select_next", "fallback" },
          ["<s-tab>"] = { "select_prev", "fallback" },
          ["<c-n>"] = { "select_next", "fallback" },
          ["<c-p>"] = { "select_prev", "fallback" },
        },
      },
      keymap = {
        ["<cr>"] = { "accept", "fallback" },
      },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          -- "dadbod",
        },
        providers = {
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
          },
        },
      },
    },
  },
}
