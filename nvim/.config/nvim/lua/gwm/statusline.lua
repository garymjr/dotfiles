local galaxyline = require('galaxyline')
local condition = require('galaxyline.condition')

local section = galaxyline.section
local buffer_not_empty = condition.buffer_not_empty

local colors = {
  fg = '#cccccc',
  fg_dark = '#999999',
  -- bg = '#242a32',
  bg = '#3a454a',
  blue = '#3592c4',
  green = '#499c54',
  red = '#c75450',
  brown = '#93896c',
  orange = '#be9117',
  inactive = '#787878'
}

section.left[1] = {
  LeftSpace = {
    provider = function() return '  ' end,
    highlight = { colors.bg, colors.bg }
  }
}

section.left[2] = {
  BufNameHead = {
    provider = function()
      local bufname = vim.fn.expand('%:h')
      local home = os.getenv('HOME')
      return bufname:gsub(home, '~')
    end,
    condition = buffer_not_empty,
    highlight = { colors.fg_dark, colors.bg },
    separator = '/',
    separator_highlight = { colors.fg_dark, colors.bg }
  }
}

section.left[3] = {
  BufNameTail = {
    provider = function()
      local tail = vim.fn.expand('%:t')
      return tail
    end,
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.bg },
    separator = ' ',
    separator_highlight = { colors.bg, colors.bg }
  }
}

section.left[4] = {
  FileType = {
    provider = function()
      local filetype = vim.bo.filetype
      if filetype and filetype ~= '' then
        return '['..filetype..']'
      end
      return ''
    end,
    separator = ' ',
    separator_highlight = { colors.bg, colors.bg },
    highlight = { colors.fg_dark, colors.bg }
  }
}

section.left[5] = {
  BufStatus = {
    provider = function()
      local modified = vim.bo.modifiable and vim.bo.modified
      local readonly = vim.bo.readonly

      if modified then
        vim.api.nvim_command('hi GalaxyBufStatus guifg='..colors.fg_dark..' guibg='..colors.bg)
        return ' '
      end

      if readonly then
        vim.api.nvim_command('hi GalaxyBufStatus guifg='..colors.red..' guibg='..colors.bg)
        return ' '
      end
    end,
    condition = buffer_not_empty,
    separator = ' ',
    separator_highlight = { colors.bg, colors.bg }
  }
}

section.right[1] = {
  LineColumn = {
    provider = 'LineColumn',
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.bg },
    separator = ' ',
    separator_highlight = { colors.fg, colors.bg }
  }
}

section.right[2] = {
  LinePercent = {
    provider = 'LinePercent',
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.bg },
    separator = ' ',
    separator_highlight = { colors.fg, colors.bg }
  }
}

section.right[3] = {
  RightSpace = {
    provider = function() return '  ' end,
    condition = buffer_not_empty,
    highlight = { colors.bg, colors.bg }
  }
}
