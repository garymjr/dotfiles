local now, later = MiniDeps.now, MiniDeps.later

now(function()
  require("mini.notify").setup()
  vim.notify = MiniNotify.make_notify()
end)

now(function()
  require("mini.statusline").setup()
end)

later(function()
  require("mini.extra").setup()
end)

later(function()
  require("mini.ai").setup()
end)

later(function()
  require("mini.bracketed").setup()
end)

later(function()
  require("mini.bufremove").setup()
  vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { silent = true, desc = "Delete buffer" })
  vim.keymap.set("n", "<leader>bD", function()
    MiniBufremove.delete(0, true)
  end, { silent = true, desc = "Delete buffer (force)" })
end)

later(function()
  local clue = require("mini.clue")
  clue.setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },

      -- Built-in completion
      { mode = "i", keys = "<c-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<c-r>" },
      { mode = "c", keys = "<c-r>" },

      -- Window commands
      { mode = "n", keys = "<c-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },

      -- mini.bracketed
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "x", keys = "[" },
      { mode = "x", keys = "]" },
    },
    clues = {
      { mode = "n", keys = "<leader><tab>", desc = "+Tabs" },
      { mode = "n", keys = "<leader>b",     desc = "+Buffers" },
      { mode = "n", keys = "<leader>b",     desc = "+Buffers" },
      { mode = "n", keys = "<leader>c",     desc = "+Code" },
      { mode = "n", keys = "<leader>f",     desc = "+Find" },
      { mode = "n", keys = "<leader>g",     desc = "+Git" },
      { mode = "n", keys = "<leader>s",     desc = "+Search" },
      { mode = "n", keys = "<leader>u",     desc = "+UI" },
      { mode = "n", keys = "<leader>w",     desc = "+Windows" },
      { mode = "n", keys = "<leader>x",     desc = "+Lists" },
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },
  })
end)

later(function()
  require("mini.comment").setup()
end)

later(function()
  require("mini.move").setup({
    mappings = {
      left = "<s-h>",
      right = "<s-l>",
      up = "<s-k>",
      down = "<s-j>",
      line_left = "",
      line_right = "",
      line_up = "",
      line_down = "",
    },
  })
end)

later(function()
  require("mini.pick").setup()
  vim.keymap.set("n", "<leader>:", "<cmd>Pick history<cr>", { silent = true, desc = "Command history" })
  vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers include_current=false<cr>", { silent = true, desc = "Buffers" })
  vim.keymap.set(
    "n",
    "<leader>fc",
    function()
      MiniPick.builtin.files({ tool = "fd" }, { source = { cwd = vim.fn.stdpath("config") } })
    end,
    {
      silent = true,
      desc = "Config"
    }
  )
  vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { silent = true, desc = "Files" })
  vim.keymap.set(
    "n",
    "<leader>fF",
    function()
      MiniPick.builtin.files({ tool = "fd" }, { source = { cwd = vim.uv.cwd() } })
    end,
    {
      silent = true,
      desc = "Files (cwd)"
    }
  )
  vim.keymap.set("n", "<leader>fg", "<cmd>Pick git_files<cr>", { silent = true, desc = "Files (git)" })
  vim.keymap.set("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { silent = true, desc = "Recent" })
  vim.keymap.set("n", "<leader>gc", "<cmd>Pick git_commits<cr>", { silent = true, desc = "Commits" })
  vim.keymap.set("n", '<leader>s"', "<cmd>Pick registers<cr>", { silent = true, desc = "Registers" })
  vim.keymap.set("n", "<leader>sb", "<cmd>Pick buf_lines<cr>", { silent = true, desc = "Buffer" })
  vim.keymap.set("n", "<leader>sc", "<cmd>Pick commands<cr>", { silent = true, desc = "Commands" })
  vim.keymap.set(
    "n",
    "<leader>sd",
    "<cmd>Pick diagnostic scope='current'<cr>",
    { silent = true, desc = "Document diagnostics" }
  )
  vim.keymap.set(
    "n",
    "<leader>sD",
    "<cmd>Pick diagnostic scope='all'<cr>",
    { silent = true, desc = "Workspace diagnostics" }
  )
  vim.keymap.set("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { silent = true, desc = "Grep" })
  vim.keymap.set(
    "n",
    "<leader>sG",
    function()
      MiniPick.builtin.grep_live({ tool = "rg" }, { source = { cwd = vim.uv.cwd() } })
    end,
    {
      silent = true,
      desc = "Grep"
    }
  )
  vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<cr>", { silent = true, desc = "Help pages" })
  vim.keymap.set("n", "<leader>sH", "<cmd>Pick hl_groups<cr>", { silent = true, desc = "Highlights" })
  vim.keymap.set("n", "<leader>sk", "<cmd>Pick keymaps<cr>", { silent = true, desc = "Keymaps" })
  vim.keymap.set("n", "<leader>sm", "<cmd>Pick marks<cr>", { silent = true, desc = "Marks" })
  vim.keymap.set("n", "<leader>so", "<cmd>Pick options<cr>", { silent = true, desc = "Options" })
  vim.keymap.set("n", "<leader>sr", "<cmd>Pick resume<cr>", { silent = true, desc = "Resume" })
  vim.keymap.set("n", "<leader>ss", "<cmd>Pick lsp scope='document_symbol'<cr>",
    { silent = true, desc = "Document symbol" })
  vim.keymap.set("n", "<leader>sS", "<cmd>Pick lsp scope='workspace_symbol'<cr>",
    { silent = true, desc = "Workspace symbol" })
end)

now(function()
  require("mini.starter").setup()
end)

later(function()
  require("mini.surround").setup({
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
  })
end)

later(function()
  require("mini.visits").setup()
end)
