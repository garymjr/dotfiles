vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- my plugins
    use '~/.config/nvim/plugins/parsec'

    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    use 'ajmwagar/vim-deus'

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-telescope/telescope-fzy-native.nvim',
      }
    }

    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'
    use { 'glepnir/lspsaga.nvim', branch = 'main' }
    use 'onsails/lspkind-nvim'

    use 'hrsh7th/nvim-compe'

    use 'hrsh7th/vim-vsnip'

    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'

    use 'justinmk/vim-sneak'

    use { 'glepnir/galaxyline.nvim', branch = 'main' }

    use 'sheerun/vim-polyglot'

    use { 'styled-components/vim-styled-components', branch = 'main' }

    use {
      disable = true,
      'kyazdani42/nvim-tree.lua'
    }

    use { 'justinmk/vim-dirvish', disable = true }

    use 'tpope/vim-vinegar'
    use 'tpope/vim-eunuch'

    use 'tjdevries/colorbuddy.nvim'
    use 'tjdevries/gruvbuddy.nvim'

    use { 'rktjmp/lush.nvim', branch = 'main' }

    use 'google/vim-searchindex'

    use 'kyazdani42/nvim-web-devicons'

    use 'nvim-treesitter/nvim-treesitter'
    use 'norcalli/nvim-colorizer.lua'

    use 'mfussenegger/nvim-dap'

    use { 'lewis6991/gitsigns.nvim', branch = 'main' }
  end
}
