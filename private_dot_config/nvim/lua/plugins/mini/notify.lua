require("mini.deps").now(function()
  require("mini.notify").setup()
  vim.notify = require("mini.notify").make_notify()
end)
