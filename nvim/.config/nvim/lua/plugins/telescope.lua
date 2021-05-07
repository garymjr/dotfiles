local remap = require('core.utils').remap
local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<c-j>'] = actions.move_selection_next,
        ['<c-k>'] = actions.move_selection_previous
      }
    }
  },
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = 'smart_case'
    }
  }
})

require('telescope').load_extension('fzf')

local function find_dots()
  require('telescope.builtin').find_files({
    cwd = string.format('%s/.config/nvim', os.getenv('HOME'))
  })
end

remap('n', '<c-p>', [[<cmd>lua require('telescope.builtin').git_files()<cr>]], { noremap = true, silent = true })
remap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], { noremap = true, silent = true })
-- remap('n', '<leader>fr', [[<cmd>History<cr>]], { noremap = true, silent = true })
-- remap('n', '<leader>fw', [[<cmd>Rg<cr>]], { noremap = true, silent = true })
remap('n', '<leader>fd', [[<cmd>lua require('plugins.telescope').find_dots()<cr>]], { noremap = true, silent = true })

return { find_dots = find_dots }
