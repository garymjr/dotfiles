vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- utilities
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- telescope
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make'
    }

    use {
      'nvim-telescope/telescope.nvim',
      config = function()
        local actions = require('telescope.actions')
        require('telescope').setup({
          defaults = {
            prompt_prefix = ' >',
            mappings = {
              i = {
                ['<C-q>'] = actions.send_to_qflist,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous
              }
            }
          },
          extensions = {
            fzf = {
              override_generic_sorter = false,
              override_file_sorter = true,
              case_mode = 'smart_case'
            }
          }
        })
        require('telescope').load_extension('fzf')
      end
    }

    -- themes
    use 'ajmwagar/vim-deus'
    use 'glepnir/zephyr-nvim'
    use 'owozsh/amora'
    use 'romgrk/doom-one.vim'
    use 'nightsense/cosmic_latte'
    use 'romainl/Apprentice'
    use 'srcery-colors/srcery-vim'

    -- treesitter
    use 'nvim-treesitter/playground'
    use {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = {
            'bash',
            'css',
            'graphql',
            'html',
            'javascript',
            'json',
            'lua',
            'php',
            'query',
            'svelte',
            'tsx',
            'typescript'
          },
          highlight = {
            enable = true,
            use_languagetree = true
          },
          indent = {
            enable = true
          },
          playground = {
            enable = true,
            updatetime = 25
          }
        }
      end
    }

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'
    use {
      'folke/lsp-trouble.nvim',
      config = function()
        local remap = require('core.utils').remap
        require('trouble').setup({
          mode = 'document'
        })
        remap('n', '<leader>xx', '<cmd>LspTroubleToggle<cr>', { silent = true, noremap = true })
      end
    }

    -- dap
    use 'mfussenegger/nvim-dap'

    -- completion
    use {
      'hrsh7th/nvim-compe',
      config = function()
        require('compe').setup {
          enabled = true,
          autocomplete = true,
          debug = false,
          preselect = 'enable',
          documentation = true,
          min_length = 1,
          throttle_time = 80,

          source = {
            buffer = true,
            nvim_lsp = true,
            nvim_lua = true
          }
        }
      end
    }

    -- snippets
    use 'hrsh7th/vim-vsnip'

    -- tpope plugins
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-eunuch'

    -- languages
    use { 'styled-components/vim-styled-components', branch = 'main', disable = true }
    use 'jxnblk/vim-mdx-js'

    -- git
    use {
      'lewis6991/gitsigns.nvim',
      branch = 'main',
      config = function()
        require 'gitsigns'.setup({
          signs = {
            add = {
              hl = 'GitSignsAdd',
              text = '▎'
            },
            change = {
              hl = 'GitSignsChange',
              text = '▎'
            },
            delete = {
              hl = 'GitSignsDelete',
              text = '◢'
            },
            topdelete = {
              hl = 'GitSignsDelete',
              text = '◥'
            },
            changedelete = {
              hl = 'GitSignsChange',
              text = '▌'
            }
          },
          current_line_blame = false
        })
      end
    }

    -- misc
    use 'google/vim-searchindex'
    use {
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup({
          default = true
        })
      end
    }
    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end
    }
    use 'mhartington/formatter.nvim'
    use { 'justinmk/vim-dirvish', disable = true }
    use {
      'tamago324/lir.nvim',
      config = function()
        local actions = require'lir.actions'
        local mark_actions = require 'lir.mark.actions'
        local clipboard_actions = require'lir.clipboard.actions'

        require('lir').setup({
          show_hidden_files = false,
          devicons_enable = true,
          mappings = {
            ['l']     = actions.edit,
            ['<C-s>'] = actions.split,
            ['<C-v>'] = actions.vsplit,
            ['<C-t>'] = actions.tabedit,

            ['h']     = actions.up,
            ['q']     = actions.quit,

            ['K']     = actions.mkdir,
            ['N']     = actions.newfile,
            ['R']     = actions.rename,
            ['@']     = actions.cd,
            ['Y']     = actions.yank_path,
            ['.']     = actions.toggle_show_hidden,
            ['D']     = actions.delete,

            ['J'] = function()
              mark_actions.toggle_mark()
              vim.cmd('normal! j')
            end,
            ['C'] = clipboard_actions.copy,
            ['X'] = clipboard_actions.cut,
            ['P'] = clipboard_actions.paste,
          }
        })
      end
    }

    use {
      'akinsho/nvim-toggleterm.lua',
      config = function()
        require('toggleterm').setup({
          size = 20,
          open_mapping = '<c-\\>',
          hide_numers = true,
          shade_terminals = true,
          start_in_insert = false,
          persist_in_size = true,
          direction = 'horizontal'
        })
      end
    }
  end
}
