local remap = require 'garymjr.utils'.remap

vim.g.mapleader = ' '

remap('v', '<', '<gv')
remap('v', '>', '>gv')
remap('n', 'Y', 'y$', { noremap = true })

remap('n', '<leader>y', '"+y', { noremap = true })
remap('n', '<leader>p', '"+p', { noremap = true })
remap('n', '<leader>P', '"+P', { noremap = true })
remap('v', '<leader>y', '"+y', { noremap = true })
remap('v', '<leader>p', '"_d"+P', { noremap = true })

remap('n', '<cr>', [[ {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}() ]], { noremap = true, expr = true })
remap('n', '<leader>ch', ':term curl https://cht.sh/', { noremap = true })

remap('n', 'j', 'gj')
remap('n', 'k', 'gk')

-- prettier
remap('n', 'gp', '<cmd>%!npx prettier --stdin-filepath %<cr>', { noremap = true })

-- easier movements
remap('n', '<c-h>', '<c-w>h', { noremap = true })
remap('n', '<c-j>', '<c-w>j', { noremap = true })
remap('n', '<c-k>', '<c-w>k', { noremap = true })
remap('n', '<c-l>', '<c-w>l', { noremap = true })

-- allow escape to enter normal mode in terminal
remap('t', '<esc>', '<c-\\><c-n>', { noremap = true })

-- lsp
remap('n', 'gh', '<cmd>lua require"lspsaga.provider".lsp_finder()<cr>', { noremap = true })
remap('n', '<leader>ca', '<cmd>lua require"lspsaga.codeaction".code_action()<cr>', { noremap = true })
-- remap('n', 'K', '<cmd>lua require"lspsaga.provider".preview_definition()<cr>', { noremap = true })
remap('n', 'K', [[<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>]], { noremap = true })
remap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = true })
remap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = true })

-- git
remap('n', '<leader>gs', '<cmd>Gstatus<cr>', { noremap = true })

-- vsnip
remap('i', '<tab>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<tab>"', { expr = true })
remap('i', '<s-tab>', 'vsnip#jumpable(-1) ? "<plug>(vsnip-jump-prev)" : "<s-tab>"', { expr = true })

remap('i', '<c-j>', 'pumvisible() ? "<c-n>" : "<c-j>"', { expr = true })
remap('i', '<c-k>', 'pumvisible() ? "<c-p>" : "<c-k>"', { expr = true })

remap('v', 'p', '"_dP', { noremap = true })
