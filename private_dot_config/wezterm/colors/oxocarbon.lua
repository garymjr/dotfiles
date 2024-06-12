local M = {}

M.foreground = "#ffffff"
M.background = "#161616"
M.cursor_bg = "#ffffff"
M.cursor_border = "#ffffff"
M.cursor_fg = "#161616"

M.ansi = {
  "#262626",
  "#ee5396",
  "#42be65",
  "#ffe97b",
  "#33b1ff",
  "#ff7eb6",
  "#3ddbd9",
  "#dde1e6",
}

M.brights = {
  "#393939",
  "#ee5396",
  "#42be65",
  "#ffe97b",
  "#33b1ff",
  "#ff7eb6",
  "#3ddbd9",
  "#ffffff",
}

M.tab_bar = {
  background = "#262626",
  active_tab = {
    bg_color = "#161616",
    fg_color = "#ffffff",
    intensity = "Normal",
    italic = false,
    strikethrough = false,
    underline = "None",
  },
  inactive_tab = {
    bg_color = "#262626",
    fg_color = "#ffffff",
    intensity = "Normal",
    italic = false,
    strikethrough = false,
    underline = "None",
  },
  new_tab = {
    bg_color = "#262626",
    fg_color = "#ffffff",
    intensity = "Normal",
    italic = false,
    strikethrough = false,
    underline = "None",
  },
}

return M
