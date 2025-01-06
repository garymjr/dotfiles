return {
  {
    "CopilotChat.nvim",
    opts = {
      auto_insert_mode = false,
      contexts = {
        file = {
          input = function(callback)
            local telescope = require("telescope.builtin")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            telescope.find_files({
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  callback(selection[1])
                end)
                return true
              end,
            })
          end,
        },
      },
      model = "claude-3.5-sonnet",
      prompts = {
        Commit = {
          selection = function() end,
        },
      },
    },
  },
  {
    "CopilotChat.nvim",
    opts = function(_, opts)
      opts.mappings = vim.tbl_deep_extend("force", {}, opts.mappings or {}, {
        complete = {
          insert = "<c-y>",
        },
        reset = {
          normal = "gx",
          insert = "",
        },
        accept_diff = {
          normal = "ga",
          insert = "<C-a>",
        },
      })
    end,
  },
}
