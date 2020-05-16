local lsp = require'nvim_lsp'

lsp.vimls.setup{on_attach=require'completion'.on_attach}
lsp.tsserver.setup{on_attach=require'completion'.on_attach}
lsp.html.setup{on_attach=require'completion'.on_attach}
