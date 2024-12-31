return {
  {
    "CopilotChat.nvim",
    opts = {
      auto_insert_mode = false,
      contexts = {
        file = {
          input = function(callback)
            local fzf = require("fzf-lua")
            local fzf_path = require("fzf-lua.path")
            fzf.files({
              complete = function(selected, opts)
                local file = fzf_path.entry_to_file(selected[1], opts, opts._uri)
                if file.path == "none" then
                  return
                end
                vim.defer_fn(function()
                  callback(file.path)
                end, 100)
              end,
            })
          end,
        },
      },
      model = "claude-3.5-sonnet",
    },
  },
  {
    "CopilotChat.nvim",
    opts = function(_, opts)
      opts.mappings = vim.tbl_deep_extend("force", {}, opts.mappings or {}, {
        complete = {
          insert = "<C-y>",
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
