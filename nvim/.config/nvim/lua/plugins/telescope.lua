local remap = require('core.utils').remap
local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    prompt_prefix = ' >',
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous
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

local function find_dots()
  require('telescope.builtin').find_files({
    prompt = '< neovim >',
    cwd = '$HOME/.config/nvim'
  })
end

remap('n', '<c-p>', [[<cmd>lua require('telescope.builtin').git_files()<cr>']], { noremap = true, silent = true })
remap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>']], { noremap = true, silent = true })
remap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers({ignore_current_buffer=true, sort_lastused=true})<cr>']], { noremap = true, silent = true })
remap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>']], { noremap = true, silent = true })
remap('n', '<leader>fd', [[<cmd>lua require('plugins.telescope').find_dots()<cr>']], { noremap = true, silent = true })

return {
  find_dots = find_dots
}
