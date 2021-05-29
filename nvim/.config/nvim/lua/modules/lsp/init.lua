local lsp = require('lspconfig')
local lsp_status = require('lsp-status')
local remap = require('core.utils').remap

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = ''
    }
  }
)

require('modules.lsp.efm')
require('modules.lsp.tsserver')
require('modules.lsp.cssls')
require('modules.lsp.sumneko')

lsp.svelte.setup {}
lsp.vimls.setup { on_attach=lsp_status.on_attach }

vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

remap('i', '<cr>', [[compe#confirm('<CR>')]], { noremap = true, expr = true })
remap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true })
-- remap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true })
-- remap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap = true })
remap('n', 'gr', [[<cmd>LspTrouble lsp_references<cr>]], { noremap = true, silent = true })
