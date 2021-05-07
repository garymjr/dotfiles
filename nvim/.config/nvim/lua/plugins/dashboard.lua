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
    command = 'Files'
  },
  recent_files = {
    description = {'ﭯ  Recent Files       SPC f r'},
    command = 'History'
  },
  find_word = {
    description = {'  Find Word          SPC f w'},
    command = 'Rg'
  }
}
