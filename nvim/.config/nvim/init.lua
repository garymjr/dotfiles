require('core')

require('plugins.devicons')
require('plugins.gitsigns')
require('plugins.dap')
require('plugins.colorizer')

require('modules.statusline').setup()
require('modules.lsp')
require('modules.treesitter')
require('modules.formatter')
require('modules.colors').colorscheme('doom-one')

require('garymjr.fzf')
require('garymjr.terminal')
