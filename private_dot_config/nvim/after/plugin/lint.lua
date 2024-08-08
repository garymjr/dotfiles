require("mini.deps").later(function()
  local lint = require("lint")
  lint.linters_by_ft = {
    fish = { "fish" },
    elixir = { "credo" },
  }

  lint.linters = {
    credo = {
      condition = function(ctx)
        return vim.fs.find({ ".credo.exs" }, { path = ctx.filename, upward = true })[1]
      end,
    },

  }
end)
