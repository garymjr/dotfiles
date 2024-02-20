local add = require("mini.deps").add

local function require_later(mod)
  require("mini.deps").later(function()
		vim.api.nvim_cmd({
			cmd = "source",
			args = {vim.fn.stdpath("config") .. "/lua/" .. mod:gsub("%.", "/") .. ".lua"},
		}, {})
  end)
end

require_later("config.options")
require_later("config.keymaps")
require_later("config.autocmds")

require("gwm.plugins.cmp")
