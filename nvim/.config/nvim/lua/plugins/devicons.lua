require('nvim-web-devicons').setup {
  default = true
}

local icons = require('nvim-web-devicons').get_icons()

local default_icon = {
  icon = "",
  color = "#6d8086",
  name = "Default",
}

local M = {}

M.get_icon = function(name, ext)
  local icon_data = icons[name]
  local by_name = icon_data

  if by_name then
    return by_name
  else
    icon_data = icons[ext]

    if not icon_data then
      icon_data = default_icon
    end

    if icon_data then
      local by_ext = icon_data
      return by_ext
    end
  end
end

return M
