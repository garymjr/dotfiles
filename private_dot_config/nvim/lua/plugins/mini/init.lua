require("mini.deps").now(function()
  require("mini.extra").setup()
end)

require("mini.deps").now(function()
  require("mini.visits").setup()
end)

require "plugins.mini.notify"
require "plugins.mini.statusline"

require "plugins.mini.ai"
require "plugins.mini.bufremove"
require "plugins.mini.files"
require "plugins.mini.icons"
require "plugins.mini.indentscope"
require "plugins.mini.pairs"
require "plugins.mini.pick"
require "plugins.mini.surround"
