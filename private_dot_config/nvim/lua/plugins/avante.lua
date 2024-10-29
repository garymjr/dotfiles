MiniDeps.add({
  source = "yetone/avante.nvim",
  depends = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "zbirenbaum/copilot.lua",
  },
})

MiniDeps.now(function()
  require("avante_lib").load()
end)

MiniDeps.later(function()
  require("copilot").setup()
end)

MiniDeps.later(function()
  require("avante").setup({
    -- debug = true,
    provider = "copilot",
    -- auto_suggestions_provider = "copilot",
    behaviour = {
      auto_suggestions = false,
      auto_apply_diff_after_generation = true,
    },
    vendors = {
      ollama = {
        ["local"] = true,
        model = "codegemma",
        endpoint = "127.0.0.1:11434/v1",
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint .. "/chat/completions",
            headers = {
              ["Accept"] = "application/json",
              ["Content-Type"] = "application/json",
            },
            body = {
              model = opts.model,
              messages = require("avante.providers").copilot.parse_message(code_opts),
              max_tokens = 2048,
              stream = true,
            },
          }
        end,
        parse_response_data = function(stream_data, event_state, opts)
          require("avante.providers").openai.parse_response(stream_data, event_state, opts)
        end,
      },
    },
  })
end)
