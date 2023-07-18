return {
    {
        "echasnovski/mini.files",
        enabled = false,
        keys = {
            {
                "-",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0))
                end,
                silent = true,
            }
        },
        config = function(_, opts)
            require("mini.files").setup(opts)
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            panel = {
                enabled = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<c-l>",
                    next = "<c-j>",
                    prev = "<c-k>",
                    dismiss = "<c-c>",
                },
            },
        },
    },
    {
        "chrisgrieser/nvim-genghis",
        keys = {
            { "<leader>rf", function() require("genghis").renameFile() end, silent = true },
            { "<leader>mf", function() require("genghis").moveAndRenameFile() end, silent = true },
            { "<leader>yf", function() require("genghis").duplicateFile() end, silent = true },
            { "<leader>df", function() require("genghis").trashFile() end, silent = true },
        },
    },
    {
        "numToStr/Navigator.nvim",
        keys = {
            {
                "<c-h>",
                function()
                    require("Navigator").left()
                end,
            },
            {
                "<c-j>",
                function()
                    require("Navigator").down()
                end,
            },
            {
                "<c-k>",
                function()
                    require("Navigator").up()
                end,
            },
            {
                "<c-l>",
                function()
                    require("Navigator").right()
                end,
            },
        },
        config = function(_, opts)
            require("Navigator").setup(opts)
        end,
    },
}
