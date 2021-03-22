local actions = require 'telescope.actions'
local sorters = require 'telescope.sorters'
local previewers = require 'telescope.previewers'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'

local filter = vim.tbl_filter
local conf = require('telescope.config').values

require'telescope'.setup {
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
      }
    }
  }
}

require'telescope'.load_extension('fzy_native')

local M = {}
M.search_dotfiles = function()
  require('telescope.builtin').find_files {
    prompt_title = '< vimrc >',
    cwd = '$HOME/dotfiles/nvim/.config/nvim'
  }
end

M.find_buffers = function(opts)
  local bufnrs = filter(function(b)
    if vim.fn.buflisted(b) ~= 1 then
      return false
    end

    -- ignore current buffer
    if vim.api.nvim_get_current_buf() == b then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then return end

  local buffers = {}
  local default_selection_idx = 1
  for _, bufnr in ipairs(bufnrs) do
    local flag = bufnr == vim.fn.bufnr('') and '%' or (bufnr == vim.fn.bufnr('#') and '#' or ' ')

    local element = {
      bufnr = bufnr,
      flag = flag,
      info = vim.fn.getbufinfo(bufnr)[1]
    }

    if flag == '#' or flag == '%' then
      local idx = ((buffers[1] ~= nil and buffers[1].flag == '%') and 2 or 1)
      table.insert(buffers, idx, element)
    else
      table.insert(buffers, element)
    end
  end

  local max_bufnr = math.max(unpack(bufnrs))
  opts.bufnr_width = #tostring(max_bufnr)

  pickers.new(opts, {
    prompt_title = 'Buffers',
    finder    = finders.new_table {
      results = buffers,
      entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts)
    },
    sorter = conf.generic_sorter(opts),
    default_selection_index = default_selection_idx,
  }):find()
end

return M
