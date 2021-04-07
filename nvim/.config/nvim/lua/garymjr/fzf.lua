local remap = require 'garymjr.utils'.remap

local M = {}

function M.find_dots()
  vim.cmd(string.format([[call fzf#vim#files('%s/.config/nvim', fzf#vim#with_preview())]], os.getenv('HOME')))
end

remap('n', '<leader>ff', '<cmd>Files<cr>', { noremap = true })
remap('n', '<leader>fh', '<cmd>Helptags<cr>', { noremap = true })
remap('n', '<leader>fb', '<cmd>Buffers<cr>', { noremap = true })
remap('n', '<leader>fd', [[<cmd>lua require'garymjr.fzf'.find_dots()<cr>]], { noremap = true })

return M
