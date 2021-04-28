local utils = require('cosmic_latte.utils')
local theme = require('cosmic_latte.theme')

local function setup()
  vim.cmd('hi clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.g.colors_name = 'cosmic_latte'

  local async
  async = vim.loop.new_async(vim.schedule_wrap(function()
    utils.setup_terminal()

    local plugins = theme.loadPlugins()
    local lsp = theme.loadLsp()

    for group, colors in pairs(plugins) do
      utils.highlight(group, colors)
    end

    for group, colors in pairs(lsp) do
      utils.highlight(group, colors)
    end
    async:close()
  end))

  local syntax = theme.loadSyntax()

  for group, colors in pairs(syntax) do
    utils.highlight(group, colors)
  end
  async:send()
end

return { setup = setup }
