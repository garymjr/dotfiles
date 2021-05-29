local remap = require('core.utils').remap

require('toggleterm').setup({
  size = 20,
  open_mapping = '<c-\\>',
  hide_numers = true,
  shade_terminals = true,
  start_in_insert = false,
  persist_in_size = true,
  -- direction = 'float',
  float_opts = {
    border = 'single',
    height = 40,
    width = 175
  }
})

remap('n', '<leader>tt', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true })
remap('n', '<leader>t1', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true })
remap('n', '<leader>t2', '<cmd>2ToggleTerm<cr>', { noremap = true, silent = true })
remap('n', '<leader>t3', '<cmd>3ToggleTerm<cr>', { noremap = true, silent = true })
