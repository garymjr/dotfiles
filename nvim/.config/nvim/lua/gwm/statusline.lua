local galaxyline = require 'galaxyline'
local gsl = galaxyline.section.left
local gsr = galaxyline.section.right

local colors = {
  fg = '#bbbbbb',
  bg = '#313335',
  blue = '#3592c4',
  green = '#499c54',
  red = '#c75450',
  brown = '#93896c',
  orange = '#be9117',
  inactive = '#787878'
}

local modes = {
  normal = {' ', colors.fg},
  insert = {'i', colors.green},
  replace = {'r', colors.red},
  visual = {'v', colors.blue},
  ['v-line'] = {'l', colors.blue},
  ['v-block'] = {'b', colors.blue},
  command = {'c', colors.brown},
  terminal = {'t', colors.green},
  ['shell-ex'] = {'!', colors.green}
}

local get_mode = function()
  local mode = vim.fn.mode()
  if mode:find('^n') ~= nil then
    return modes.normal
  elseif mode:find('^i') ~= nil then
    return modes.insert
  elseif mode:find('^R') ~= nil then
    return modes.replace
  elseif mode == 'v' then
    return modes.visual
  elseif mode == 'V' then
    return modes['v-line']
  elseif mode == '' then
    return modes['v-block']
  elseif mode:find('^c') ~= nil then
    return modes.command
  elseif mode == 't' then
    return modes.terminal
  elseif mode == '!' then
    return modes['shell-ex']
  end
  return {mode, colors.fg}
end

gsl[1] = {
  Space = {
    provider = function() return ' ' end,
    highlight = {colors.fg, colors.bg}
  }
}

gsl[2] = {
  ViMode = {
    provider = function()
      local mode = get_mode()
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode[2]..' guibg='..colors.bg..' gui=bold')
      return mode[1]
    end,
    separator = ' ',
    separator_highlight = {colors.fg, colors.bg}
  }
}

gsl[3] = {
  BufName = {
    provider = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == nil then
        return ''
      end
      local parts = vim.split(bufname, '/')
      return parts[#parts]
    end,
    highlight = {colors.fg, colors.bg, 'italic'},
    separator = ' ',
    separator_highlight = {colors.fg, colors.bg}
  }
}

gsl[4] = {
  BufStatus = {
    provider = function()
      local modified = vim.bo.modifiable and vim.bo.modified
      local readonly = vim.bo.readonly

      if modified then
        vim.api.nvim_command('hi GalaxyBufStatus guifg='..colors.brown..' guibg='..colors.bg)
        return '*'
      end

      if readonly then
        vim.api.nvim_command('hi GalaxyBufStatus guifg='..colors.red..' guibg='..colors.bg)
        return 'ro'
      end
    end,
    separator = ' ',
    separator_highlight = {colors.fg, colors.bg}
  }
}

gsr[1] = {
  CurrentFunction = {
    provider = function()
      local current_function = vim.b.lsp_current_function
      if current_function and current_function ~= '' then
        return '[  '..current_function..']'
      end
      return ''
    end,
    highlight = {colors.fg, colors.bg},
    separator = ' ',
    separator_highlight = {colors.fg, colors.bg}
  }
}

gsr[2] = {
  Space = {
    provider = function() return ' ' end,
    highlight = {colors.fg, colors.bg}
  }
}

gsr[3] = {
  LineColumn = {
    provider = 'LineColumn',
    highlight = {colors.fg, colors.bg},
    separator = ' ',
    separator_highlight = {colors.fg, colors.bg}
  }
}

gsr[4] = {
  LinePercent = {
    provider = 'LinePercent',
    highlight = {colors.fg, colors.bg},
    separator = ' ',
    separator_highlight = {colors.fg, colors.bg}
  }
}
