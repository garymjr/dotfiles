require("config.deps")

_G.Config = {
  copilot = false,
  gitsigns = false,
  native_comments = true,
  use_epo = false,
}

require("gwm.utils").source_plugins(vim.fn.stdpath("config") .. "/lua/plugins")
