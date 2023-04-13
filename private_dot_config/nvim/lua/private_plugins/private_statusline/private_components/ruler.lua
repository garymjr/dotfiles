local conditions = require("heirline.conditions")

return {
    {
        condition = function()
            return not conditions.is_active()
        end,
        { provider = "%l:%v %p%%" },
        { provider = " " },
    },
    {
        condition = conditions.is_active,
        {
            { provider = " " },
            { provider = "%l:%v %P" },
            { provider = " " },
        },
    },
}
