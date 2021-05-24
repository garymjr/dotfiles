local section = require('galaxyline').section
local condition = require('galaxyline.condition')

local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')

local left = section.left
local right = section.right

local buffer_not_empty = condition.buffer_not_empty
local check_git_workspace = condition.check_git_workspace
local hide_in_width = condition.hide_in_width

local colors = {
  green = '#9ed072',
  yellow = '#e7c664',
  red = '#fc5d7c',
  bg = '#3b3e48'
}

left[1] = {
  SpaceStart = {
    provider = function()
      return ' '
    end,
    highlight = {nil, colors.bg}
  }
}

left[2] = {
  BufName = {
    provider = function()
      return vim.fn.expand('%:t')
    end,
    condition = buffer_not_empty,
    highlight = {nil, colors.bg},
    separator = ' ',
    separator_highlight = {nil, colors.bg}
  }
}

left[4] = {
  Modified = {
    provider = function()
      local modified = vim.bo.modifiable and vim.bo.modified
      if modified then
        return ''
      end
      return ''
    end,
    condition = buffer_not_empty,
    highlight = {nil, colors.bg}
  }
}

left[5] = {
  Readonly = {
    provider = function()
      local readonly = vim.bo.readonly
      if readonly then
        return ''
      end
      return ''
    end,
    condition = buffer_not_empty,
    highlight = {colors.red, colors.bg},
  }
}

right[1] = {
  FileType = {
    provider = function()
      local ft = vim.bo.filetype
      local bt = vim.bo.buftype
      if ft ~= '' then
        return '['..ft..']'
      elseif bt ~= '' then
        return '['..bt..']'
      end
      return ''
    end,
    condition = buffer_not_empty,
    highlight = {nil, colors.bg}
  }
}

right[2] = {
  GitIcon = {
    provider = function()
      return ' '
    end,
    condition = check_git_workspace,
    highlight = {nil, colors.bg},
    separator = ' ',
    separator_highlight = {nil, colors.bg}
  }
}

right[3] = {
  GitBranch = {
    provider = vcs.get_git_branch,
    condition = check_git_workspace,
    highlight = {nil, colors.bg}
  }
}

right[4] = {
  Space = {
    provider = function()
      return ' '
    end,
    highlight = {nil, colors.bg}
  }
}

right[5] = {
  DiffAdd = {
    provider = vcs.diff_add,
    condition = hide_in_width,
    icon = ' ',
    highlight = {colors.green, colors.bg}
  }
}

right[6] = {
  DiffModified = {
    provider = vcs.diff_modified,
    condition = hide_in_width,
    icon = ' ',
    highlight = {colors.yellow, colors.bg}
  }
}

right[7] = {
  DiffRemove = {
    provider = vcs.diff_remove,
    condition = hide_in_width,
    icon = ' ',
    highlight = {colors.red, colors.bg}
  }
}

right[8] = {
  LineColumn = {
    provider = fileinfo.line_column,
    condition = buffer_not_empty,
    highlight = {nil, colors.bg},
    separator = '',
    separator_highlight = {nil, colors.bg}
  }
}

right[9] = {
  SpaceEnd = {
    provider = function()
      return ' '
    end,
    highlight = {nil, colors.bg}
  }
}
