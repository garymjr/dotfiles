require('core')

require('plugins.devicons')
require('plugins.dap')
require('plugins.telescope')
require('plugins.trouble')
require('plugins.compe')
require('plugins.gitsigns')
require('plugins.lir')
require('plugins.toggleterm')

require('modules.statusline').setup()
require('modules.treesitter')
require('modules.lsp')
require('modules.formatter')
require('modules.colors')

require('garymjr.fzf')
