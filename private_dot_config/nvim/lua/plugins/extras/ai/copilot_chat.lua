return {
  {
    "CopilotChat.nvim",
    branch = "canary",
    opts = function(_, opts)
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)

      opts.model = "claude-3.5-sonnet"
    end,
  },
}
