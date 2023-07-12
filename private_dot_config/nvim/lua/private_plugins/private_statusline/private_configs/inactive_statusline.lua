local buffer_name = require("plugins.statusline.components.buffer_name")
local ruler = require("plugins.statusline.components.ruler")

return {
    buffer_name,
    { provider = "%< %=" },
    ruler,
}
