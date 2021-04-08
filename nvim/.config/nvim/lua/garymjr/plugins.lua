vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- my plugins
    use '~/.config/nvim/plugins/parsec'
    use '~/.config/nvim/plugins/apprentice'
    use '~/.config/nvim/plugins/colorscheme-extractor'

    -- fzf
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- utilities
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- themes
    use 'ajmwagar/vim-deus'
    use 'sainnhe/everforest'
    use 'metalelf0/jellybeans-nvim'
    use 'junegunn/seoul256.vim'
    use 'sff1019/hogwarts.vim'
    use 'senran101604/neotrix.vim'

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

    -- languages
    use { 'styled-components/vim-styled-components', branch = 'main', disable = true }

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
