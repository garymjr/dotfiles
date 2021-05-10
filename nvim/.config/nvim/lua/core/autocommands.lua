local create_autogroup = require('core.utils').create_autogroup

create_autogroup {
  group_name = 'quickfix',
  definition = {{ 'FileType', 'qf', 'wincmd J' }}
}

create_autogroup {
  group_name = 'packer',
  definition = {{ 'BufWritePost', 'plugins.lua', 'luafile %' }}
}

create_autogroup {
  group_name = 'highlight_yank',
  definition = {{ 'TextYankPost', '*', [[silent! lua require('vim.highlight').on_yank { timeout = 40 }]]  }}
}

create_autogroup {
  group_name = 'terminal',
  definition = {
    { 'TermOpen', '*', 'setlocal norelativenumber nonumber' },
    { 'BufEnter', 'term://*', 'stopinsert' }
  }
}
