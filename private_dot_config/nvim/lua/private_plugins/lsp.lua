return {
    {
        "neovim/nvim-lspconfig",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            "folke/neodev.nvim",
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "nvim-telescope/telescope.nvim",
            "j-hui/fidget.nvim",
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
            },
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            diagnostics = {
                                globals = {"vim"},
                            },
                        },
                    },
                },
            },
            setup = {},
        },
        config = function(_, opts)
            for _, name in ipairs({"Error", "Warn", "Info", "Hint"}) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = "●", texthl = name, numhl = "" })
            end
            vim.diagnostic.config(opts)

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            local function setup(server)
                local server_opts = servers[server] or {}
                server_opts.capabilities = capabilities
                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            local mlsp = require("mason-lspconfig")
            local available = mlsp.get_available_servers()

            local ensure_installed = {}
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    if server_opts.mason == false or not vim.tbl_contains(available, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed+1] = server
                    end
                end
            end

            require("mason-lspconfig").setup({ ensure_installed = ensure_installed, handlers = { setup } })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    client.server_capabilities.semanticTokensProvider = nil
                    local buf = args.buf
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, silent = true })
                    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { buffer = buf, silent = true })
                    vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references, { buffer = buf, silent = true })
                    vim.keymap.set("n", "gI", require('telescope.builtin').lsp_implementations, { buffer = buf, silent = true })
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, silent = true })
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, silent = true })
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, silent = true })
					vim.keymap.set("n", "<leader>s", require('telescope.builtin').lsp_document_symbols, { buffer = buf, silent = true })
					vim.keymap.set("n", "<leader>ws", require('telescope.builtin').lsp_dynamic_workspace_symbols, { buffer = buf, silent = true })
                end,
            })
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            window = {
                blend = 0,
            },
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        enabled = false,
        event = "BufReadPre",
        dependencies = {"mason.nvim"},
        opts = function()
            local nls = require("null-ls")
            return {
                sources = {
                    nls.builtins.formatting.goimports,
                }
            }
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            ensure_installed = {},
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },
}
