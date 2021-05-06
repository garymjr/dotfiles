require('compe').setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  preselect = 'enable',
  documentation = true,
  min_length = 1,
  throttle_time = 80,

  source = {
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true
  }
})
