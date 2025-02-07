local M = {}

function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      vim.notify(" Requesting assistance (" .. request.data.strategy .. ")", "info", {
        id = "codecompanion_progress",
        title = "CodeCompanion",
      })
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      if request.data.status == "success" then
        vim.notify("Completed", "info", {
          id = "codecompanion_progress",
          title = "CodeCompanion",
        })
      elseif request.data.status == "error" then
        vim.notify(" Error", "error", {
          id = "codecompanion_progress",
          title = "CodeCompanion",
        })
      else
        vim.notify("󰜺 Cancelled", "warning", {
          id = "codecompanion_progress",
          title = "CodeCompanion",
        })
      end
    end,
  })
end

return M
