local remap = require('core.utils').remap
local function find_dots()
  require('telescope.builtin').find_files({
    prompt = '< neovim >',
    cwd = '$HOME/.config/nvim'
  })
end

remap('n', '<c-p>', [[<cmd>lua require('telescope.builtin').git_files()<cr>']], { noremap = true, silent = true })
remap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>']], { noremap = true, silent = true })
remap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>']], { noremap = true, silent = true })
remap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>']], { noremap = true, silent = true })
remap('n', '<leader>fd', [[<cmd>lua require('plugins.telescope').find_dots()<cr>']], { noremap = true, silent = true })

return {
  find_dots = find_dots
}
