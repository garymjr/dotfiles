local parsers = require 'nvim-treesitter.parsers'
local queries = require 'nvim-treesitter.query'
local ts_utils = require 'nvim-treesitter.ts_utils'

local hlmap = vim.treesitter.highlighter.hl_map
local api = vim.api

local M = {}

M.create_autogroup = function(config)
  local group_name = config.group_name
  local definition = config.definition
  vim.cmd('augroup ' .. group_name)
  vim.cmd [[ autocmd! ]]
  for _, def in ipairs(definition) do
    local command = table.concat(vim.tbl_flatten { 'autocmd ', def }, ' ')
    vim.cmd(command)
  end
  vim.cmd [[ augroup END ]]
end

M.hilite = function(group, opts)
  local bg = 'NONE'
  if opts.bg then
    bg = opts.bg
  end
  local fg = 'NONE'
  if opts.fg then
    fg = opts.fg
  end

  local hi_opts = ' guibg='..bg..' guifg='..fg
  if opts.gui then
    hi_opts = hi_opts .. ' gui='..opts.gui
  end

  if opts.sp then
    hi_opts = hi_opts .. ' guisp='..opts.sp
  end

  local cmd = 'hi ' .. group .. hi_opts
  vim.cmd(cmd)
end

function M.get_highlight_group()
  local group = api.nvim_exec([[ echo synIDattr(synID(line('.'), col('.'), 1), 'name') ]], true)
  local base_group = api.nvim_exec([[ echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') ]], true)

  local content = {'Group: ' .. group, 'BaseGroup: ' .. base_group}
  local opts = {
    relative = 'cursor',
    width = 25,
    height = 2,
    style = 'minimal',
    col = 0,
    row = 1
  }

  local bufnr = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
  api.nvim_buf_set_option(bufnr, 'modifiable', false)
  api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  api.nvim_open_win(bufnr, true, opts)
end

function M.show_hl_captures()
  local bufnr = api.nvim_get_current_buf()
  local lang = parsers.get_buf_lang(bufnr)

  if not lang then return end

  local row, col = unpack(api.nvim_win_get_cursor(0))
  row = row - 1

  local parser = parsers.get_parser(bufnr, lang)
  if not parser then return function() end end

  local root = parser:parse()[1]:root()
  if not root then return end
  local start_row, _, end_row, _ = root:range()

  local matches = {}
  local query = queries.get_query(lang, 'highlights')
  for _, match in query:iter_matches(root, bufnr, start_row, end_row) do
    for id, node in pairs(match) do
      if ts_utils.is_in_node_range(node, row, col) then
        local c = query.captures[id]
        if c ~= nil then
          table.insert(matches, '@' .. c .. ' -> ' .. (hlmap[c] or 'nil'))
        end
      end
    end
  end

  if #matches == 0 then
    matches = {'No tree-sitter matches found!'}
  end

  vim.lsp.util.open_floating_preview(matches, 'treesitter-hl-captures')
end

function M.set_option(key, value)
  local scope = api.nvim_get_option_info(key).scope
  if type(value) == 'table' then
    value = table.concat(value, ',')
  end

  if scope == 'win' then
    vim.wo[key] = value
  elseif scope == 'buf' then
    vim.bo[key] = value
  end
  vim.o[key] = value
end

return M
