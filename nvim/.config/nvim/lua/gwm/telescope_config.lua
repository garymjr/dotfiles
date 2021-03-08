local actions = require 'telescope.actions'
local sorters = require 'telescope.sorters'
local previewers = require 'telescope.previewers'

require'telescope'.setup{
  defaults = {
    file_sorter = sorters.get_fzy_sorter,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    mappings = {
      i = {
        ['<c-j>'] = actions.move_selection_next,
        ['<c-k>'] = actions.move_selection_previous
      }
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true
      },
      fzf_writer = {
        minimum_grep_characters = 2,
        use_highlighter = true
      }
    }
  }
}

require'telescope'.load_extension('fzy_native')

local M = {}
M.search_dotfiles = function()
  require 'telescope.builtin'.find_files {
    prompt_title = '< vimrc >',
    cwd = '$HOME/dotfiles/nvim/.config/nvim'
  }
end

return M
