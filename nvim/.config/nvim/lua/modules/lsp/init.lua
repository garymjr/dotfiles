local lsp = require('lspconfig')
local saga = require('lspsaga')
local compe = require('compe')
local lsp_status = require('lsp-status')
local remap = require('core.utils').remap

require('modules.lsp.efm')
require('modules.lsp.tsserver')
require('modules.lsp.cssls')
require('modules.lsp.sumneko')

lsp.svelte.setup {}
lsp.vimls.setup { on_attach=lsp_status.on_attach }

saga.init_lsp_saga {
  code_action_prompt = {
    enable = false
  }
}

compe.setup {
  enabled = true,
  autocomplete = true,
  debug = true,
  preselect = 'enable',
  documentation = true,

  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true,
    treesitter = true
  };
}

vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

remap('n', 'gh', '<cmd>lua require"lspsaga.provider".lsp_finder()<cr>', { noremap = true })
remap('n', '<leader>ca', '<cmd>lua require"lspsaga.codeaction".code_action()<cr>', { noremap = true })
remap('n', 'K', [[<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>]], { noremap = true })
remap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true })
remap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true })
