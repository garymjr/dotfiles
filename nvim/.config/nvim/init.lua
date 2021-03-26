local set_option = require('gwm.utils').set_option
require('dap').set_log_level('TRACE')

require 'gwm.plugins'
require 'gwm.devicons'
require 'gwm.nvim-tree'
require 'gwm.lsp_config'
require 'gwm.telescope_config'
require 'gwm.statusline'
require 'gwm.treesitter'
require 'gwm.autocommands'
require 'gwm.mappings'
require 'gwm.git'
require 'gwm.dap'

set_option('background', 'dark')
set_option('clipboard', { 'unnamed', 'unnamedplus' })
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
set_option('showmode', false)
set_option('swapfile', false)
set_option('undofile', false)
set_option('wrap', false)
set_option('path', { '.', '/usr/include', '**' })
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

vim.cmd [[
  command! TSHighlightsUnderCursor :lua require('gwm.utils').show_hl_captures()
]]
vim.cmd [[
  command! TerminalTab :-tabnew term://zsh
]]

vim.g.netrw_keepdir = 0
vim.g.netrw_localrmdir = 'rm -r'

-- require('colorbuddy').colorscheme('parsec')
require 'gwm.colors'.setup()
require 'colorizer'.setup()
