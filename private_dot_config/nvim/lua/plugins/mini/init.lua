MiniDeps.now(function()
	require("mini.extra").setup()
end)

MiniDeps.now(function()
  require("mini.statusline").setup()
end)

MiniDeps.now(function()
	require("mini.visits").setup()
end)

require("plugins.mini.notify")

MiniDeps.later(function()
  require("mini.cursorword").setup()
end)

MiniDeps.later(function()
  require("mini.git").setup()
end)

require("plugins.mini.ai")
require("plugins.mini.bufremove")
require("plugins.mini.diff")
require("plugins.mini.files")
require("plugins.mini.hipatterns")
require("plugins.mini.icons")
require("plugins.mini.indentscope")
require("plugins.mini.pairs")
require("plugins.mini.pick")
require("plugins.mini.surround")
