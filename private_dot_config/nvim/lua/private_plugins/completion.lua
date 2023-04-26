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
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
					{ name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                experimental = {
                    ghost_text = false,
                    -- ghost_text = {
                    --     hl_group = "LspCodeLens",
                    -- },
                },
                window = {
                    completion = cmp.config.window.bordered({
                        winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
                        scrollbar = true,
                        border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                        col_offset = -1,
                        side_padding = 0,
                    }),
                    documentation = cmp.config.window.bordered({
                        winhighlight = "Normal:Pmenu,FloatBorder:PmenuDocBorder,CursorLine:PmenuSel,Search:None",
                        scrollbar = true,
                        border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
                        side_padding = 1,
                    }),
                },
            }
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            panel = {
                enabled = true,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<c-e>",
                    accept_line = "<c-E>",
                    next = "<c-j>",
                    prev = "<c-k>",
                },
            },
        },
    },
}
