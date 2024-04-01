require("config.deps")

_G.Config = {
  cmp = true,
  copilot = false,
  gitsigns = false,
}

require("gwm.utils").source_plugins(vim.fn.stdpath("config") .. "/lua/plugins")
