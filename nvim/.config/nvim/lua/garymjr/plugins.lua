vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- my plugins
    use '~/.config/nvim/plugins/parsec'
    use '~/.config/nvim/plugins/apprentice'
    use '~/.config/nvim/plugins/hypsteria'

    -- fzf
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- utilities
    use { 'nvim-lua/popup.nvim', disable = false }
    use { 'nvim-lua/plenary.nvim', disable = false }

    -- themes
    use 'ajmwagar/vim-deus'
    use 'sainnhe/everforest'

    -- TODO: I should really decide on colorbuddy or lush
    use 'tjdevries/colorbuddy.nvim'
    use 'tjdevries/gruvbuddy.nvim'
    use { 'rktjmp/lush.nvim', branch = 'main' }

    -- treesitter
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'
    use { 'glepnir/lspsaga.nvim', branch = 'main' }

    -- dap
    use 'mfussenegger/nvim-dap'

    -- completion
    use 'hrsh7th/nvim-compe'

    -- snippets
    use 'hrsh7th/vim-vsnip'

    -- tpope plugins
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-eunuch'

    -- statusline
    use { 'glepnir/galaxyline.nvim', branch = 'main', disable = true }

    -- languages
    use 'sheerun/vim-polyglot'
    use { 'styled-components/vim-styled-components', branch = 'main' }

    -- git
    use { 'lewis6991/gitsigns.nvim', branch = 'main' }

    -- misc
    use 'google/vim-searchindex'
    use 'kyazdani42/nvim-web-devicons'
    use 'norcalli/nvim-colorizer.lua'
    use 'nacro90/numb.nvim'
    use 'justinmk/vim-dirvish'
  end
}
