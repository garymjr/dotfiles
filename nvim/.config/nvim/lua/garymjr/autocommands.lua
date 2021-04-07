local create_autogroup = require 'garymjr.utils'.create_autogroup

create_autogroup {
  group_name = 'quickfix',
  definition = {{ 'FileType', 'qf', 'wincmd J' }}
}

create_autogroup {
  group_name = 'packer',
  definition = {{ 'BufWritePost', '**/gwm/plugins.lua', 'PackerCompile' }}
}

create_autogroup {
  group_name = 'highlight_yank',
  definition = {{ 'TextYankPost', '*', [[ silent! lua require('vim.highlight').on_yank { timeout = 40 } ]]  }}
}
