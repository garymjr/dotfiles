local set_normal_map = function(before, after)
  vim.api.nvim_set_keymap('n', before, after, {noremap = true, silent = true})
end

vim.g.mapleader = ' '

vim.api.nvim_set_keymap('v', '<', '<gv', {})
vim.api.nvim_set_keymap('v', '>', '>gv', {})
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true})

set_normal_map('j', 'gj')
set_normal_map('k', 'gk')

-- telescope
set_normal_map('<leader>ff', '<cmd>lua require"telescope.builtin".find_files()<cr>')
set_normal_map('<leader>fg', '<cmd>lua require"telescope".extensions.fzf_writer.grep()<cr>')
set_normal_map('<leader>fh', '<cmd>lua require"telescope.builtin".help_tags()<cr>')
set_normal_map('<leader>fd', '<cmd>lua require"gwm.telescope_config".search_dotfiles()<cr>')
set_normal_map('<tab>', '<cmd>lua require"telescope.builtin".buffers()<cr>')

-- chadtree
set_normal_map('<leader>e', '<cmd>NvimTreeToggle<cr>')

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

-- vsnip
vim.api.nvim_set_keymap('i', '<tab>', 'vsnip#available(1) ? "<plug>(vsnip-expand-or-jump)" : "<tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<s-tab>', 'vsnip#jumpable(-1) ? "<plug>(vsnip-jump-prev)" : "<s-tab>"', {expr = true})

vim.api.nvim_set_keymap('i', '<c-j>', 'pumvisible() ? "<c-n>" : "<c-j>"', {expr = true})
vim.api.nvim_set_keymap('i', '<c-k>', 'pumvisible() ? "<c-p>" : "<c-k>"', {expr = true})
