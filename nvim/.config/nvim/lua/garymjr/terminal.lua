local remap = require('core.utils').remap

local api = vim.api
local fn = vim.fn

local terminal = {
  bufnr = nil,
  winid = nil,
  pid = nil
}

terminal.open = function()
  local bufnr = nil

  if terminal.bufnr and api.nvim_buf_is_loaded(terminal.bufnr) then
    bufnr = terminal.bufnr
  else
    bufnr = api.nvim_create_buf(false, true)
  end

  local width = math.ceil(vim.o.columns * 0.8)
  local height = math.ceil(vim.o.lines * 0.9)

  local winid = api.nvim_open_win(bufnr, true, {
    relative = 'editor',
    style = 'minimal',
    width = width,
    height = height,
    col = math.ceil((vim.o.columns - width) / 2),
    row = math.ceil((vim.o.lines - height) / 2 - 1)
  })

  if not terminal.bufnr then
    terminal.pid = fn.termopen(string.format('%s --login', os.getenv('SHELL')))
  end

  vim.cmd [[autocmd! TermClose <buffer> lua require('garymjr.terminal').close(true)]]

  terminal.winid = winid
  terminal.bufnr = bufnr
end

terminal.close = function(force)
  if not terminal.winid then
    return
  end

  if api.nvim_win_is_valid(terminal.winid) then
    api.nvim_win_close(terminal.winid, false)
    terminal.winid = nil
  end

  if force then
    if api.nvim_buf_is_loaded(terminal.bufnr) then
      api.nvim_buf_delete(terminal.bufnr, { force = true })
    end

    fn.jobstop(terminal.pid)

    terminal.bufnr = nil
    terminal.winid = nil
  end
end

terminal.toggle = function()
  if not terminal.winid then
    terminal.open()
  else
    terminal.close()
  end
end

remap('n', '<leader>tt', [[<cmd>silent lua require('garymjr.terminal').toggle()<cr>]], { noremap = true })

return terminal
