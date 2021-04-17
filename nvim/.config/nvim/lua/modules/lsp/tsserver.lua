local lspconfig = require 'lspconfig'
local lsp_status = require 'lsp-status'

lspconfig.tsserver.setup {
  on_attach=lsp_status.on_attach,
  cmd = {
    'typescript-language-server',
    '--stdio',
    '--tsserver-path='..os.getenv('HOME')..'/.nvm/versions/node/v14.15.1/bin/tsserver'
  }
}
