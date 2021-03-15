require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'css',
    'graphql',
    'html',
    'javascript',
    'json',
    'lua',
    'typescript'
  },
  highlight = {
    enable = true,
    use_languagetree = true
  }
}
