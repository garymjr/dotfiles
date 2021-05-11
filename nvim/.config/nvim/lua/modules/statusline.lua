local section = require('galaxyline').section
local left = section.left
local right = section.right

local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')

local function has_buffer()
  return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
end

local function has_filetype()
  return vim.bo.filetype ~= ''
end

local function has_buftype()
  return vim.bo.buftype ~= ''
end

local amora_colors = {
  green = '#a2baa8',
  yellow = '#eacac0',
  red = '#fb5c8e'
}

left[1] = {
  SpaceStart = {
    provider = function()
      return ' '
    end,
    highlight = {nil, '#634e75'},
    separator = ' '
  }
}

left[2] = {
  BufName = {
    provider = function()
      if vim.fn.empty(vim.fn.expand('%:t')) == 1 then
        return vim.bo.filetype
      end
      return vim.fn.expand('%:t')
    end,
    condition = function()
      return require('modules.statusline').has_buffer() or require('modules.statusline').has_filetype()
    end,
    separator = ' '
  }
}

left[3] = {
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
    condition = function()
      return require('modules.statusline').has_filetype() or require('modules.statusline').has_buftype()
    end,
    separator = ' '
  }
}

left[4] = {
  Modified = {
    provider = function()
      local modified = vim.bo.modifiable and vim.bo.modified
      if modified then
        return ''
      end
      return ''
    end,
    condition = function()
      return require('modules.statusline').has_buffer()
    end
  }
}

left[5] = {
  Readonly = {
    provider = function()
      local readonly = vim.bo.readonly
      if readonly then
        return ''
      end
      return ''
    end,
    condition = function()
      return require('modules.statusline').has_buffer()
    end
  }
}

right[1] = {
  GitIcon = {
    provider = function()
      return ' '
    end,
    condition = vcs.check_git_workspace
  }
}

right[2] = {
  GitBranch = {
    provider = vcs.get_git_branch,
    condition = vcs.check_git_workspace
  }
}

right[3] = {
  Space = {
    provider = function()
      return ' '
    end
  }
}

local function checkwidth()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

right[4] = {
  DiffAdd = {
    provider = vcs.diff_add,
    condition = checkwidth,
    icon = ' ',
    highlight = {amora_colors.green}
  }
}

right[5] = {
  DiffModified = {
    provider = vcs.diff_modified,
    condition = checkwidth,
    icon = ' ',
    highlight = {amora_colors.yellow}
  }
}

right[6] = {
  DiffRemove = {
    provider = vcs.diff_remove,
    condition = checkwidth,
    icon = ' ',
    highlight = {amora_colors.red}
  }
}

right[7] = {
  LineColumn = {
    provider = fileinfo.line_column,
    separator = ''
  }
}

right[8] = {
  SpaceEnd = {
    provider = function()
      return ' '
    end
  }
}

return {
  has_buffer = has_buffer,
  has_filetype = has_filetype,
  has_buftype = has_buftype
}
