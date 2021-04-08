local set_option = require 'garymjr.utils'.set_option

require 'garymjr.plugins'
require 'garymjr.mappings'
-- require 'garymjr.netrw'
require 'garymjr.statusline'
require 'garymjr.devicons'
require 'garymjr.gitsigns'
require 'garymjr.dap'
require 'garymjr.lsp'
require 'garymjr.treesitter'
require 'garymjr.autocommands'
require 'garymjr.fzf'

set_option('background', 'dark')
set_option('complete', { '.','w','b','u' })
set_option('completeopt', { 'menuone', 'noinsert', 'noinsert' })
set_option('expandtab', true)
set_option('fileformats', 'unix')
set_option('hidden', true)
set_option('ignorecase', true)
set_option('inccommand', 'nosplit')
set_option('laststatus', 2)
set_option('mouse', 'a')
set_option('backup', false)
set_option('modeline', false)
set_option('showmode', true)
set_option('swapfile', false)
set_option('undofile', false)
set_option('wrap', false)
set_option('path', { '.', '/usr/include', '**' })
set_option('relativenumber', true)
set_option('scrolloff', 3)
set_option('sidescrolloff', 3)
set_option('shiftwidth', 2)
set_option('shortmess', 'filnxtToOFAIWac')
set_option('signcolumn', 'yes')
set_option('smartcase', true)
set_option('splitbelow', true)
set_option('splitright', true)
set_option('tabstop', 2)
set_option('termguicolors', true)
set_option('ttimeoutlen', 0)
set_option('updatetime', 1000)
set_option('grepprg', 'rg --vimgrep --no-heading --smart-case')
set_option('guicursor', '')

local wildignore = {
  '*/tmp/*',
  '*.so',
  '*.swp',
  '*.zip',
  '*.pyc',
  '*.db',
  '*.sqlite',
  '*.o',
  '*.obj',
  '.git',
  '*.rbc',
  '__pycache__',
  'node_modules/**',
  '**/node_modules/**'
}
set_option('wildignore', wildignore)
set_option('wildmode', 'list:longest,list:full')

require 'garymjr.colors'.setup({ colorscheme = 'apprentice' })
require 'colorizer'.setup()
