local remap = require('core.utils').remap

vim.g.mapleader = ' '

remap('v', '<', '<gv')
remap('v', '>', '>gv')
remap('n', 'Y', 'y$', { noremap = true })

-- copy/paste from clipboard
remap('n', '<leader>y', '"+y', { noremap = true })
remap('n', '<leader>p', '"+p', { noremap = true })
remap('n', '<leader>P', '"+P', { noremap = true })
remap('v', '<leader>y', '"+y', { noremap = true })
remap('v', '<leader>p', '"_d"+P', { noremap = true })

remap('n', '<cr>', [[ {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}() ]], { noremap = true, expr = true })

remap('n', 'j', 'gj')
remap('n', 'k', 'gk')

-- allow escape to enter normal mode in terminal
remap('t', '<esc>', '<c-\\><c-n>', { noremap = true })

-- git
remap('n', '<leader>gs', '<cmd>Git<cr>', { noremap = true })
remap('n', '<leader>gb', '<cmd>Git blame<cr>', { noremap = true })

-- vsnip
remap('i', '<tab>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<tab>"', { expr = true })
remap('i', '<s-tab>', 'vsnip#jumpable(-1) ? "<plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true })

remap('i', '<c-j>', 'pumvisible() ? "<c-n>" : "<c-j>"', { expr = true })
remap('i', '<c-k>', 'pumvisible() ? "<c-p>" : "<c-k>"', { expr = true })

remap('v', 'p', '"_dP', { noremap = true })
