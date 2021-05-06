local theme = require('parsec.theme')
local utils = require('parsec.utils')

local function load_theme()
  vim.cmd('highlight clear')
  vim.cmd('syntax reset')
  vim.g.colors_name = 'parsec'

  local async
  async = vim.loop.new_async(vim.schedule_wrap(function()
    local plugins = theme.loadPlugins()

    for group, colors in pairs(plugins) do
      utils.highlight(group, colors)
    end

    local lsp = theme.loadLSP()

    for group, colors in pairs(lsp) do
      utils.highlight(group, colors)
    end

    local ts = theme.loadTreesitter()

    for group, colors in pairs(ts) do
      utils.highlight(group, colors)
    end
    async:close()
  end))

  local ui = theme.loadUI()

  for group, colors in pairs(ui) do
    utils.highlight(group, colors)
  end

  local syntax = theme.loadSyntax()

  for group, colors in pairs(syntax) do
    utils.highlight(group, colors)
  end

  async:send()
end

return { load_theme = load_theme }
