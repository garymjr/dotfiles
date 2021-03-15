local galaxyline = require 'galaxyline'
local get_icon = require('nvim-web-devicons').get_icon
local gs = galaxyline.section

local api = vim.api

local colors = {
  fg = '#bbbbbb',
  bg = '#373c45',
  blue = '#3592c4',
  green = '#499c54',
  red = '#c75450',
  brown = '#93896c',
  orange = '#be9117',
  inactive = '#787878'
}

gs.left[1] = {
  LeftRounded = {
    provider = function()
      return '  '
    end,
    separator = ' ',
    separator_highlight = { colors.bg, colors.bg },
    highlight = { colors.bg }
  }
}

gs.left[2] = {
  FileIcon = {
    provider = "FileIcon",
    condition = buffer_not_empty,
    highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg}
  }
}

gs.left[3] = {
  BufName = {
    provider = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == nil then
        return ''
      end
      local parts = vim.split(bufname, '/')
      return parts[#parts]
    end,
    highlight = { colors.fg, colors.bg, 'italic' },
    separator = ' ',
    separator_highlight = { colors.fg, colors.bg }
  }
}

gs.left[4] = {
  BufStatus = {
    provider = function()
      local modified = vim.bo.modifiable and vim.bo.modified
      local readonly = vim.bo.readonly

      if modified then
        vim.api.nvim_command('hi GalaxyBufStatus guifg='..colors.fg..' guibg='..colors.bg)
        return ' '
      end

      if readonly then
        vim.api.nvim_command('hi GalaxyBufStatus guifg='..colors.red..' guibg='..colors.bg)
        return ' '
      end
    end,
    separator = ' ',
    separator_highlight = { colors.fg, colors.bg }
  }
}

gs.left[5] = {
  RightRounded = {
    provider = function()
      return ''
    end,
    highlight = { colors.bg }
  }
}

gs.right[1] = {
  LeftRounded = {
    provider = function()
      return ''
    end,
    highlight = { colors.bg }
  }
}

gs.right[2] = {
  CurrentFunction = {
    provider = function()
      local current_function = vim.b.lsp_current_function
      if current_function and current_function ~= '' then
        return '[  '..current_function..']'
      end
      return ''
    end,
    highlight = { colors.fg, colors.bg },
    separator = ' ',
    separator_highlight = { colors.bg, colors.bg }
  }
}

gs.right[3] = {
  Space = {
    provider = function() return ' ' end,
    highlight = { colors.fg, colors.bg }
  }
}

gs.right[4] = {
  LineColumn = {
    provider = 'LineColumn',
    highlight = { colors.fg, colors.bg },
    separator = ' ',
    separator_highlight = { colors.fg, colors.bg }
  }
}

gs.right[5] = {
  LinePercent = {
    provider = 'LinePercent',
    highlight = { colors.fg, colors.bg },
    separator = ' ',
    separator_highlight = { colors.fg, colors.bg }
  }
}
