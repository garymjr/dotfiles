require("config.deps")

_G.Config = {
  cmp = false,
  gitsigns = false,
}

require("gwm.utils").source_plugins(vim.fn.stdpath("config") .. "/lua/plugins")
