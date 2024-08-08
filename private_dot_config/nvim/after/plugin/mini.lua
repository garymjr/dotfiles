require("mini.deps").now(function()
  require("mini.extra").setup()
  require("mini.notify").setup()
  vim.notify = function(msg, level)
    local notify = MiniNotify.make_notify()
    if level == nil then
      return
    end

    vim.print(level)
    notify(msg, level)
  end

  require("mini.starter").setup()
  require("mini.statusline").setup()
end)

require("mini.deps").later(function()
  local ai = require("mini.ai")

  ai.setup {
    n_lines = 500,
    custom_textobjects = {
      o = ai.gen_spec.treesitter({ -- code block
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
      d = { "%f[%d]%d+" },                                                          -- digits
      e = {                                                                         -- Word with case
        { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
        "^().*()$",
      },
      u = ai.gen_spec.function_call(),                           -- u for "Usage"
      U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
    },
  }

  require("mini.files").setup {
    windows = {
      preview = false,
      width_focus = 30,
      width_preview = 30,
    },
    options = {
      use_as_default_explorer = true,
    },
  }

  require("mini.icons").setup {
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
  }

  require("mini.indentscope").setup {
    symbol = "│",
    options = { try_as_border = true },
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "alpha",
      "dashboard",
      "fzf",
      "help",
      "lazy",
      "lazyterm",
      "mason",
      "neo-tree",
      "notify",
      "toggleterm",
      "Trouble",
      "trouble",
    },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })

  -- use mini.icons to replace web-devicons
  package.preload["nvim-web-devicons"] = function()
    require("mini.icons").mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end

  require("mini.pairs").setup {
    modes = { insert = true, command = true, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
  }

  require("mini.pick").setup {
    mappings = {
      caret_left        = "<Left>",
      caret_right       = "<Right>",
      choose            = "<CR>",
      choose_in_split   = "<C-s>",
      choose_in_tabpage = "<C-t>",
      choose_in_vsplit  = "<C-v>",
      choose_marked     = "<M-CR>",
      delete_char       = "<BS>",
      delete_char_right = "<Del>",
      delete_word       = "<C-w>",
      mark              = "<C-x>",
      mark_all          = "<C-a>",
      move_down         = "<C-n>",
      move_start        = "<C-g>",
      move_up           = "<C-p>",
      paste             = "<C-r>",
      refine            = "<C-Space>",
      refine_marked     = "<M-Space>",
      scroll_down       = "<C-j>",
      scroll_left       = "<C-h>",
      scroll_right      = "<C-l>",
      scroll_up         = "<C-k>",
      stop              = "<Esc>",
      toggle_info       = "<S-Tab>",
      toggle_preview    = "<Tab>",
    },
  }

  require("mini.pick").registry.chezmoi = function()
    local opts = {
      source = {
        items = require("chezmoi.commands").list({
          args = {
            "--path-style",
            "absolute",
            "--include",
            "files",
            "--exclude",
            "externals",
          },
        }),
        name = "Chezmoi",
      }
    }

    local item = MiniPick.start(opts)
    if item then
      require("chezmoi.commands").edit({ targets = { item } })
    end
  end

  require("mini.surround").setup {
    mappings = {
      add = "gsa",            -- Add surrounding in Normal and Visual modes
      delete = "gsd",         -- Delete surrounding
      find = "gsf",           -- Find surrounding (to the right)
      find_left = "gsF",      -- Find surrounding (to the left)
      highlight = "gsh",      -- Highlight surrounding
      replace = "gsr",        -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  }
end)
