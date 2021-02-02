local lsp = require 'lspconfig'
local saga = require 'lspsaga'
local compe = require 'compe'
local actions = require 'telescope.actions'

require 'plugins'

lsp.tsserver.setup{}
lsp.vimls.setup{}
saga.init_lsp_saga()

compe.setup{
  enabled = true;
  autocomplete = true;
  preselect = 'enable';

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous
      }
    }
  }
}
