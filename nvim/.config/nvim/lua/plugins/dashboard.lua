vim.g.dashboard_custom_header = {
  [[    _                _ _    __     ___           ]],
  [[   / \   _ __   ___ | | | __\ \   / (_)_ __ ___  ]],
  [[  / _ \ | '_ \ / _ \| | |/ _ \ \ / /| | '_ ` _ \ ]],
  [[ / ___ \| |_) | (_) | | | (_) \ V / | | | | | | |]],
  [[/_/   \_\ .__/ \___/|_|_|\___/ \_/  |_|_| |_| |_|]],
  [[        |_|                                      ]]
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
    description = {'  Recent Search      SPC f w'},
    command = 'Telescope search_history'
  },
  help_tags = {
    description = {'ﲉ  Help               SPC f h'},
    command = 'Telescope help_tags'
  }
}
