local lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup {
  capabilities = capabilities,
  settings = {
    css = {
      validate = true
    },
    less = {
      validate = true
    },
    scss = {
      validate = false
    }
  }
}
