require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c',
    'css',
    'graphql',
    'html',
    'javascript',
    'json',
    'lua',
    'typescript'
  },
  highlight = { enable = true }
}
