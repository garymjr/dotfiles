local harpoon = require("plugins.statusline.components.harpoon")
local buffer_name = require("plugins.statusline.components.buffer_name")
local buffer_status = require("plugins.statusline.components.buffer_status")
local ruler = require("plugins.statusline.components.ruler")
local diagnostics = require("plugins.statusline.components.diagnostics")

return {
    harpoon,
    buffer_name,
    { provider = "%<" },
    buffer_status,
    { provider = "%=" },
    diagnostics,
    ruler,
}
