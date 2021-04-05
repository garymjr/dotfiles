local set_normal_map = function(before, after)
  vim.api.nvim_set_keymap('n', before, after, {noremap = true, silent = true})
end

local remap = function(mode, before, after, opts)
  vim.api.nvim_set_keymap(mode, before, after, opts or {})
end

vim.g.mapleader = ' '

remap('v', '<', '<gv')
remap('v', '>', '>gv')
remap('n', 'Y', 'y$', { noremap = true })

remap('n', '<cr>', [[ {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}() ]], { noremap = true, expr = true })
remap('n', '<leader>fg', ":lua require('telescope.builtin').grep_string({ search = vim.fn.input('Search Files: ') })<cr>", { noremap = true })
remap('n', '<leader>ch', ':term curl https://cht.sh/', { noremap = true })

set_normal_map('j', 'gj')
set_normal_map('k', 'gk')

-- telescope
set_normal_map('<leader>ff', '<cmd>lua require"gwm.telescope_config".find_files()<cr>')
set_normal_map('<leader>fh', '<cmd>lua require"telescope.builtin".help_tags()<cr>')
set_normal_map('<leader>fd', '<cmd>lua require"gwm.telescope_config".search_dotfiles()<cr>')
-- set_normal_map('<tab>', '<cmd>lua require"telescope.builtin".buffers()<cr>')
set_normal_map('<tab>', '<cmd>lua require"gwm.telescope_config".find_buffers({sort_lastused = true, ignore_current_buffer = true})<cr>')

-- prettier
set_normal_map('gp', '<cmd>%!npx prettier --stdin-filepath %<cr>')

-- easier movements
set_normal_map('<c-h>', '<c-w>h')
set_normal_map('<c-j>', '<c-w>j')
set_normal_map('<c-k>', '<c-w>k')
set_normal_map('<c-l>', '<c-w>l')

-- allow escape to enter normal mode in terminal
vim.api.nvim_set_keymap('t', '<esc>', '<c-\\><c-n>', {noremap = true})

-- lsp
set_normal_map('gh', '<cmd>lua require"lspsaga.provider".lsp_finder()<cr>')
set_normal_map('<leader>ca', '<cmd>lua require"lspsaga.codeaction".code_action()<cr>')
set_normal_map('K', '<cmd>lua require"lspsaga.provider".preview_definition()<cr>')
set_normal_map('gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

-- git
remap('n', '<leader>gs', [[ <cmd>Gstatus<cr> ]], { noremap = true })

-- vsnip
remap('i', '<tab>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<tab>"', {expr = true})
remap('i', '<s-tab>', 'vsnip#jumpable(-1) ? "<plug>(vsnip-jump-prev)" : "<s-tab>"', {expr = true})

remap('i', '<c-j>', 'pumvisible() ? "<c-n>" : "<c-j>"', {expr = true})
remap('i', '<c-k>', 'pumvisible() ? "<c-p>" : "<c-k>"', {expr = true})

remap('v', 'p', '"_dP', { noremap = true })
