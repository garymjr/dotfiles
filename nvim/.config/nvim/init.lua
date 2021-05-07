require('core')

require('plugins.devicons')
require('plugins.dap')
require('plugins.telescope')
require('plugins.trouble')
require('plugins.compe')
require('plugins.gitsigns')
require('plugins.lir')
require('plugins.toggleterm')
require('plugins.dashboard')

require('modules.statusline').setup()
require('modules.treesitter')
require('modules.lsp')
require('modules.formatter')
require('modules.colors').colorscheme('amora')

require('garymjr.fzf')
