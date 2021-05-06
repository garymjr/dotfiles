require('toggleterm').setup({
  size = 20,
  open_mapping = '<c-\\>',
  hide_numers = true,
  shade_terminals = true,
  start_in_insert = false,
  persist_in_size = true,
  direction = 'float',
  float_opts = {
    border = 'single',
    height = 40,
    width = 175
  }
})
