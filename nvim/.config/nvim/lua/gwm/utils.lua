local parsers = require "nvim-treesitter.parsers"
local queries = require'nvim-treesitter.query'
local ts_utils = require'nvim-treesitter.ts_utils'

local hlmap = vim.treesitter.highlighter.hl_map
local api = vim.api

local M = {}

function M.nvim_create_autogroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.cmd('augroup ' .. group_name)
    vim.cmd('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.cmd(command)
    end
    vim.cmd('augroup END')
  end
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

  if group ~= '' or base_group ~= '' then
    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
    api.nvim_buf_set_option(bufnr, 'modifiable', false)
    api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
    api.nvim_open_win(bufnr, true, opts)
  end
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

return M
