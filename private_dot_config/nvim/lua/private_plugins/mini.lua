return {
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
		enabled = false,
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },
    {
        "echasnovski/mini.surround",
        keys = function(plugin, keys)
            local opts = plugin.opts
            local mappings = {
                { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
                { opts.mappings.delete, desc = "Delete surrounding" },
                { opts.mappings.find, desc = "Find right surrounding" },
                { opts.mappings.find_left, desc = "Find left surrounding" },
                { opts.mappings.highlight, desc = "Highlight surrounding" },
                { opts.mappings.replace, desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },

            }
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "gza",
                delete = "gzd",
                find = "gzf",
                find_left = "gzF",
                highlight = "gzh",
                replace = "gzr",
                update_n_lines = "gzn",
            },
        },
        config = function(_, opts)
            require("mini.surround").setup(opts)
        end,
    },
    {
        "echasnovski/mini.comment",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        event = "VeryLazy",
        opts = {
            hooks = {
                pre = function()
                    require("ts_context_commentstring.internal").update_commentstring({})
                end,
            },
        },
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end
    },
}
