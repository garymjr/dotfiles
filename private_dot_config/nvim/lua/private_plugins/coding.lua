return {
    {
        "L3MON4D3/LuaSnip",
        opts = {
            history = true,
            region_check_events = "InsertEnter",
            delete_check_events = "InsertLeave",
        },
        keys = {
            {
                "<c-d>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<c-d>"
                end,
                expr = true, silent = true, mode = "i",
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        opts = function()
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },
                experimental = {
                    ghost_text = false,
                },
                fields = {"abbr", "menu"},
                formatting = {
                    format = function(entry, vim_item)
                        if vim.tbl_contains({"path", entry.source.name}) then
                            local icon, hl_group = require("nvim-web-devicons").get_icon(
                                entry:get_completion_item_kind().label
                            )
                            if icon then
                                vim_item.kind = icon
                                vim_item.kind_hl_group = hl_group
                                return vim_item
                            end
                        end
                        return require("lspkind").cmp_format({
                            mode = "symbol_text",
                        })(entry, vim_item)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({
                        select = false,
                        behavior = cmp.ConfirmBehavior.Replace,
                    }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-y>"] = nil,
                }),
                preselect = cmp.PreselectMode.None,
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sorting = defaults.sorting,
                sources = cmp.config.sources({
                    { name = "nvim_lsp", group_index = 2 },
					{ name = "nvim_lua", group_index = 2  },
                    { name = "luasnip", group_index = 2 },
                    { name = "buffer", group_index = 2 },
                    { name = "path", group_index = 2 },
                    { name = "nvim_lsp_signature_help" },
                }),
            }
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
    },
    {
        "echasnovski/mini.comment",
        keys = {"gcc", { "gc", mode = "v" }},
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end,
    },
}
