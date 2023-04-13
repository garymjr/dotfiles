return {
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        config = function()
            require("fidget").setup()
        end,
    },
    {
        "prichrd/netrw.nvim",
        event = "VeryLazy",
        enabled = false,
        dependencies = {
            "tpope/vim-vinegar",
        },
        config = function()
            require("netrw").setup()
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
        config = function()
            require("nvim-web-devicons").setup({
                default = true,
            })
        end,
    },
    {
        "rest-nvim/rest.nvim",
        cmd = {"Rest"},
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("rest-nvim").setup()
        end,
    },
    {
        "tpope/vim-surround",
        keys = {"cs", "ds", "ysiw"}
    }
}
