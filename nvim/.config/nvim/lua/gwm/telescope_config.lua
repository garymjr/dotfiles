local actions = require 'telescope.actions'

require'telescope'.setup{
  defaults = {
    mappings = {
      i = {
        ['<c-j>'] = actions.move_selection_next,
        ['<c-k>'] = actions.move_selection_previous
      }
    }
  }
}

require'telescope'.load_extension('fzy_native')
