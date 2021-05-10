vim.g.dashboard_custom_header = {
  [[                       _           ]],
  [[ _ __   ___  _____   _(_)_ __ ___  ]],
  [[| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ ]],
  [[| | | |  __/ (_) \ V /| | | | | | |]],
  [[|_| |_|\___|\___/ \_/ |_|_| |_| |_|]]
}

vim.g.dashboard_custom_section = {
  find_file = {
    description = {'  Find File          SPC f f'},
    command = 'Telescope file_files'
  },
  recent_files = {
    description = {'ﭯ  Recent Files       SPC f r'},
    command = 'Telescope oldfiles'
  },
  find_word = {
    description = {'  Recent Search      SPC f s'},
    command = 'Telescope search_history'
  },
  help_tags = {
    description = {'ﲉ  Help               SPC f h'},
    command = 'Telescope help_tags'
  }
}
