require("mini.deps").add "xvzc/chezmoi.nvim"
require("mini.deps").later(function()
  require("chezmoi").setup {
    edit = {
      watch = false,
      force = false,
    },
    notification = {
      on_open = true,
      on_apply = true,
      on_watch = false,
    },
  }

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { os.getenv "HOME" .. "/.local/share/chezmoi/*" },
    callback = function()
      vim.schedule(require("chezmoi.commands.__edit").watch)
    end,
  })

  require("mini.pick").registry.chezmoi = function()
    local items = require("chezmoi.commands").list {
      args = {
        "-i",
        "files",
        "-x",
        "dirs,externals",
      },
    }
    table.sort(items)
    local source = {
      items = items,
      name = "Chezmoi",
      choose = function() end,
    }
    local item = MiniPick.start { source = source }
    if item == nil then return end
    require("chezmoi.commands").edit {
      targets = string.format("%s/%s", os.getenv "HOME", item),
      args = { "--watch" },
    }
  end
end)
