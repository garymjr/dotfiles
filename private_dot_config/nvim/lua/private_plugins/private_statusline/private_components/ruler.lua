local conditions = require("heirline.conditions")

return {
    {
        condition = function()
            return not conditions.is_active()
        end,
        { provider = " " },
    },
    {
        { provider = "%l:%v %p%%" },
        { provider = " " },
    },
}
