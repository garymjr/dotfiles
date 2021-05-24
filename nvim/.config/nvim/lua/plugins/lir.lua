local actions = require('lir.actions')
local mark_actions = require('lir.mark.actions')
local clipboard_actions = require('lir.clipboard.actions')
local lvim = require('lir.vim')
local utils = require('lir.utils')
local Path = require('plenary.path')

local get_context = lvim.get_context


local function new_file()
  local name = vim.fn.input('Create new file: ')
  if name == '' then
    return
  end
  local ctx = get_context()
  local path = Path:new(ctx.dir .. name)
  if path:exists() then
    utils.error('File exists!')
    return
  end

  path:touch()
  actions.reload()
end

require('lir').setup({
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l']     = actions.edit,
    ['<cr>']  = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h']     = actions.up,
    ['-']     = actions.up,
    ['q']     = actions.quit,

    ['K']     = actions.mkdir,
    ['N']     = new_file,
    ['R']     = actions.rename,
    ['@']     = actions.cd,
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['D']     = actions.delete,

    ['J'] = function()
      mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,
    ['C'] = clipboard_actions.copy,
    ['X'] = clipboard_actions.cut,
    ['P'] = clipboard_actions.paste,
  }
})
