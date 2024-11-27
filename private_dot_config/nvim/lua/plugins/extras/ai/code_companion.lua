local function codeCompanionPrompt()
  -- Check if we're in visual mode
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" then
    -- Get visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], {})
    local selected_text = table.concat(lines, "\n")

    vim.ui.input({ prompt = "Enter your prompt: " }, function(input)
      if input then
        vim.cmd(string.format("'<,'>CodeCompanion %s", input))
      end
    end)
  else
    -- Normal mode
    vim.ui.input({ prompt = "Enter your prompt: " }, function(input)
      if input then
        vim.cmd("CodeCompanion " .. input)
      end
    end)
  end
end

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "plenary.nvim",
      "nvim-treesitter",
      "nvim-cmp",
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
      { "stevearc/dressing.nvim", opts = {} },
    },
    cmd = {
      "CodeCompanionChat",
      "CodeCompanionActions",
      "CodeCompanion",
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { silent = true, desc = "Toggle CodeCompanion" },
        mode = { "n", "v" },
      },
      {
        "<leader>am",
        "<cmd>CodeCompanionActions<cr>",
        { silent = true, desc = "Open CodeCompanion Actions" },
        mode = { "n", "v" },
      },
      { "<leader>aq", codeCompanionPrompt, desc = "AI Prompt", mode = { "n", "v" } },
      {
        "<leader>as",
        "<cmd>CodeCompanionChat Add<cr>",
        desc = "Add selected text to CodeCompanion",
        silent = true,
        mode = { "v" },
      },
    },
    opts = {
      display = {
        diff = {
          provider = "mini_diff",
        },
      },
      strategies = {
        chat = {
          adapter = "copilot",
          keymaps = {
            close = {
              modes = {
                n = "q",
              },
              callback = "keymaps.close",
              index = 3,
              description = "Close Chat",
            },
          },
          roles = {
            llm = "  CodeCompanion",
            user = "  User",
          },
        },
        inline = {
          adapter = "copilot",
        },
        agent = {
          ["flow"] = {
            description = "Adding flow to your code",
            system_prompt = [[
              You are an AI assistant integrated with Neovim using the CodeCompanion plugin. Your capabilities include:

              1. **Command Runner Tool:**
              - You can run terminal commands on the user's system.

              2. **Editor Tool:**
              - You can interact with the Neovim editor to navigate, modify, and enhance the user’s code or text within active buffers.

              3. **Files Tool:**
              - You can read, create, update, delete, and rename files or directories in the file system.

              **Key Responsibilities:**

              - Respect user privacy and the principle of least privilege: only access or modify what is necessary.
              - Ask for explicit user confirmation before making any destructive or irreversible changes, such as deleting files or running risky commands.
              - Provide clear, concise explanations for actions before performing them.
              - Prioritize improving productivity, code quality, and providing contextual, accurate suggestions or solutions.

              **Additional Guidelines:**

              - Always follow the user’s preferences and align your responses with their current programming context.
              - Explain your reasoning when performing non-trivial operations.
              - Ensure all operations are safe and reversible where possible.

              With this knowledge, support the user in their development tasks effectively. Ask for clarification whenever needed.
            ]],
            tools = {
              "cmd_runner",
              "editor",
              "files",
            },
          },
          ["commit"] = {
            description = "Generate commit messages",
            system_prompt = "You are able to generate commit messages based on the staged changes in your repository. You have access to the git command and can use it to obtain a current diff of the staged changes.",
            tools = {
              "cmd_runner",
            },
          },
        },
      },
    },
  },
}
