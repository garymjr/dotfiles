local config = require("config")

MiniDeps.add("mfussenegger/nvim-lint")
MiniDeps.later(function()
  local lint = require("lint")
  lint.linters = config.linters
  lint.linters_by_ft = config.linters_by_ft
end)
