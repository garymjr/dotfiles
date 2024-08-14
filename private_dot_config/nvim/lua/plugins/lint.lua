local config = require("config")

require("mini.deps").add("mfussenegger/nvim-lint")
require("mini.deps").later(function()
  local lint = require("lint")
  lint.linters = config.linters
  lint.linters_by_ft = config.linters_by_ft
end)
