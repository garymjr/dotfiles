require('core')

require('plugins.devicons')
require('plugins.dap')
require('plugins.telescope')

require('modules.statusline').setup()
require('modules.lsp')
require('modules.formatter')
require('modules.colors').colorscheme('doom-one')

require('garymjr.fzf')
