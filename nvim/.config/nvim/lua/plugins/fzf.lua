local remap = require('core.utils').remap

local function find_dots()
  vim.cmd(string.format([[call fzf#vim#files('%s/.config/nvim', fzf#vim#with_preview())]], os.getenv('HOME')))
end

remap('n', '<c-p>', '<cmd>GitFiles<cr>', { noremap = true, silent = true })
remap('n', '<leader>ff', [[<cmd>Files<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fb', [[<cmd>Buffers<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fh', [[<cmd>Helptags<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fr', [[<cmd>History<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fw', [[<cmd>Rg<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fd', [[<cmd>lua require('plugins.fzf').find_dots()<cr>]], { noremap = true, silent = true })

return { find_dots = find_dots }
