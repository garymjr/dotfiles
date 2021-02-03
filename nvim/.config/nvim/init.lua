vim.api.nvim_set_option('background', 'dark')
vim.api.nvim_set_option('clipboard', 'unnamed,unnamedplus')

-- complete
local complete = {'.','w','b','u'}
vim.api.nvim_set_option('complete', table.concat(complete, ','))

vim.api.nvim_set_option('completeopt', 'menuone,noinsert,noselect')
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('fileformats', 'unix')
vim.api.nvim_set_option('hidden', true)
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('inccommand', 'nosplit')
vim.api.nvim_set_option('laststatus', 2)
vim.api.nvim_set_option('mouse', 'a')
vim.api.nvim_set_option('backup', false)
vim.api.nvim_set_option('modeline', false)
vim.api.nvim_set_option('showmode', false)
vim.api.nvim_set_option('swapfile', false)
vim.api.nvim_set_option('undofile', false)
vim.api.nvim_set_option('wrap', false)
vim.api.nvim_set_option('path', '.,/usr/include,**')
vim.api.nvim_set_option('scrolloff', 3)
vim.api.nvim_set_option('sidescrolloff', 3)
vim.api.nvim_set_option('shiftwidth', 2)
vim.api.nvim_set_option('shortmess', 'filnxtToOFAIWac')
vim.api.nvim_set_option('smartcase', true)
vim.api.nvim_set_option('splitbelow', true)
vim.api.nvim_set_option('splitright', true)
vim.api.nvim_set_option('tabstop', 2)
vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_set_option('ttimeoutlen', 0)
vim.api.nvim_set_option('updatetime', 1000)

-- wildignore
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
  '*/node_modules/*'
}
vim.api.nvim_set_option('wildignore', table.concat(wildignore, ','))
vim.api.nvim_set_option('wildmode', 'list:longest,list:full')

vim.g.colors_name = 'zenburn'

local chadtree_settings = {
  theme = {
    text_colour_set = 'nerdtree_syntax_dark'
  }
}
vim.api.nvim_set_var('chadtree_settings', chadtree_settings)

require 'gwm.plugins'
require 'gwm.lsp_config'
require 'gwm.telescope_config'
require 'gwm.mappings'
require 'gwm.autocommands'

require'colorbuddy'.colorscheme('onebuddy')
