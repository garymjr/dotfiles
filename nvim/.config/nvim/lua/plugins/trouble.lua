local remap = require('core.utils').remap

require('trouble').setup({
  mode = 'document'
})

remap('n', '<leader>xx', '<cmd>LspTroubleToggle<cr>', { silent = true, noremap = true })
