local autogroups = {
  quickfix = {{'FileType', 'qf', 'wincmd J'}},
  no_cursorline_in_insert_mode = {
    {'InsertEnter,WinLeave', '*', 'set nocursorline'},
    {'InsertLeave,WinEnter', '*', 'set cursorline'}
  },
  vimrc = {{'BufWritePost', '$MYVIMRC', 'so $MYVIMRC'}},
  packer = {{'BufWritePost', '**/gwm/plugins.lua', 'PackerCompile'}}
}

require'gwm.utils'.nvim_create_autogroups(autogroups)
