return {
    {
        "echasnovski/mini.files",
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
        -- event = "VeryLazy",
		cmd = {"Rename", "Move", "Duplicate", "Delete"},
        init = function()
            vim.api.nvim_create_user_command("Rename", function() require("genghis").renameFile() end, {})
            vim.api.nvim_create_user_command("Move", function() require("genghis").moveAndRenameFile() end, {})
            vim.api.nvim_create_user_command("Delete", function() require("genghis").trashFile() end, {})
            vim.api.nvim_create_user_command("Duplicate", function() require("genghis").duplicateFile() end, {})
        end,
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
