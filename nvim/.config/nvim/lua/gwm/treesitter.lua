require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'css',
    'graphql',
    'html',
    'javascript',
    'json',
    'lua',
    'php',
    'svelte',
    'tsx',
    'typescript'
  },
  highlight = {
    enable = true,
    use_languagetree = true
  },
  indent = {
    enable = true
  }
}
