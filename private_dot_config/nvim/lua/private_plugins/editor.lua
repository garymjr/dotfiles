return {
    {
        "tamago324/lir.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            {
                "-",
                function()
                    local buf = vim.api.nvim_buf_get_name(0)
                    local dir = vim.fn.fnamemodify(buf, ":h")
                    vim.cmd(string.format("edit %s", dir))
                end,
                silent = true,
            }
        },
        opts = function()
            local actions = require("lir.actions")
            local mark_actions = require("lir.mark.actions")
            local clipboard_actions = require("lir.clipboard.actions")

            return {
                show_hidden_files = false,
                devicons = {
                    enabled = true,
                },
                mappings = {
                    ["<CR>"] = actions.edit,
                    ["<C-s>"] = actions.split,
                    ["<C-v>"] = actions.vsplit,
                    U = actions.up,
                    q = actions.quit,
                    d = actions.mkdir,
                    ["%"] = actions.newfile,
                    R = actions.rename,
                    ["@"] = actions.cd,
                    Y = actions.yank_path,
                    ["."] = actions.toggle_show_hidden,
                    D = actions.delete,
                    J = function()
                        mark_actions.toggle_mark()
                        vim.cmd("normal! j")
                    end,
                    C = clipboard_actions.copy,
                    X = clipboard_actions.cut,
                    P = clipboard_actions.paste,
                },
                hide_cursor = false,
            }
        end,
        init = function()
            require("nvim-web-devicons").set_icon({
                lir_folder_icon = {
                    icon = "",
                    color = "#7ebae4",
                    name = "LirFolderNode"
                }
            })
        end,
    },
    {
        "tamago324/lir-git-status.nvim",
        event = "VeryLazy",
        dependencies = {
            "tamago324/lir.nvim",
        },
        config = function()
            require("lir.git_status").setup({
                show_ignored = false,
            })
        end,
        init = function()
            vim.cmd("hi link LirGitStatusBracket WhiteSpace")
            vim.cmd("hi link LirGitStatusUntracked WhiteSpace")
            vim.cmd("hi link LirGitStatusIgnored WhiteSpace")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
        },
        keys = {
            {
                "<leader>f",
                function()
                    require("telescope.builtin").find_files()
                end,
                silent = true,
            },
            {
                "<leader>gf",
                function()
                    local files_ok = pcall(require("telescope.builtin").git_files, {})
                    if not files_ok then
                        require("telescope.builtin").find_files()
                    end
                end,
                silent = true,
            },
            {
                "<leader>b",
                function()
                    require("telescope.builtin").buffers({ sort_lastused = true })
                end,
                silent = true,
            },
            {
                "<leader>?",
                function()
                    require("telescope.builtin").help_tags()
                end,
                silent = true,
            },
            {
                "<leader>o",
                function()
                    require("telescope.builtin").oldfiles()
                end,
                silent = true,
            },
            {
                "<leader>/",
                function()
                    require("telescope.builtin").live_grep()
                end,
                silent = true,
            },
            {
                "<leader>ec",
                function()
                    require("telescope.builtin").find_files({
                        cwd = vim.fn.stdpath("config"),
                    })
                end,
                silent = true,
            },
            {
                "<leader>ed",
                function()
                    require("telescope.builtin").find_files({
                        cwd = string.format("%s/.local/share/dotfiles", os.getenv("HOME")),
                        hidden = true,
                    })
                end,
            },
            {
                "<leader>D",
                function()
                    require("telescope.builtin").diagnostics()
                end,
                silent = true,
            },
        },
        opts = {
            defaults = {
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8
                    },
                    width = 0.90,
                    height = 0.80,
                    preview_cutoff = 120
                },
                sorting_strategy = "ascending",
                selection_strategy = "reset",
                winblend = 0,
                mappings = {
                    i = {
                        ["<C-h>"] = "which_key",
                        ["<C-r>"] = "to_fuzzy_refine",
                    },
                },
            },
            extentions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case"
                }
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("fzf")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▁" },
                topdelete = { text = "▔" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
            end,
        }
    },
    {
        "ThePrimeagen/harpoon",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            {
                "<leader>ha",
                function()
                    require("harpoon.ui").toggle_quick_menu()
                end,
                silent = true,
            },
            {
                "<leader>hA",
                function()
                    require("harpoon.mark").add_file()
                end,
            },
            {
                "<leader>h1",
                function()
                    require("harpoon.ui").nav_file(1)
                end,
                silent = true,
            },
            {
                "<leader>h2",
                function()
                    require("harpoon.ui").nav_file(2)
                end,
                silent = true,
            },
            {
                "<leader>h3",
                function()
                    require("harpoon.ui").nav_file(3)
                end,
                silent = true,
            },
            {
                "<leader>h4",
                function()
                    require("harpoon.ui").nav_file(4)
                end,
                silent = true,
            },
            {
                "[h",
                function()
                    require("harpoon.ui").nav_prev()
                end,
                silent = true,
            },
            {
                "]h",
                function()
                    require("harpoon.ui").nav_next()
                end,
                silent = true,
            },
        },
    },
    {
        "numToStr/Navigator.nvim",
        event = "VeryLazy",
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
    {
        "chrisgrieser/nvim-genghis",
		event = "VeryLazy",
        config = function()
            vim.api.nvim_create_user_command("Rename", require("genghis").moveAndRenameFile, {})
            vim.api.nvim_create_user_command("Move", require("genghis").moveAndRenameFile, {})
            vim.api.nvim_create_user_command("Duplicate", require("genghis").duplicateFile, {})
            vim.api.nvim_create_user_command("Delete", require("genghis").trashFile, {})
        end,
    },
    {
        "Bekaboo/deadcolumn.nvim",
        event = "VeryLazy",
    },
}
