require("mini.deps").add("brianaung/compl.nvim")
require("mini.deps").later(function()
  require("compl").setup()
end)
