local function prompt_codecompanion()
  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
      if input then
        vim.cmd("'<,'>CodeCompanion " .. input)
      end
    end)
  else
    vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
      if input then
        vim.cmd("CodeCompanion " .. input)
      end
    end)
  end
end

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionChat toggle<cr>", desc = "Toggle (CodeCompanion)", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "Promp Actions (CodeCompanion)", mode = { "n", "v" } },
      {
        "<leader>aq",
        function()
          prompt_codecompanion()
        end,
        desc = "Prompt (CodeCompanion)",
        mode = { "n", "v" },
      },
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.5-sonnet",
              },
            },
          })
        end,
      },
      display = {
        diff = {
          provider = "mini_diff",
        },
      },
      strategies = {
        chat = {
          keymaps = {
            close = {
              modes = {
                n = "q",
              },
              index = 4,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = {
                n = "<c-c>",
                i = "<c-c>",
              },
              index = 5,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
          slash_commands = {
            buffer = {
              opts = {
                provider = "fzf_lua",
              },
            },
            file = {
              opts = {
                provider = "fzf_lua",
              },
            },
            help = {
              opts = {
                provider = "fzf_lua",
              },
            },
            symbols = {
              opts = {
                provider = "fzf_lua",
              },
            },
          },
        },
      },
    },
  },
  {
    "blink.cmp",
    opts = {
      sources = {
        default = { "codecompanion" },
        providers = {
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
          },
        },
      },
    },
  },
}
