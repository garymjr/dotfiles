vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-telescope/telescope-fzy-native.nvim'
    }
  }

  use 'neovim/nvim-lspconfig'
  use 'wbthomason/lsp-status.nvim'
  use {'glepnir/lspsaga.nvim', branch = 'main'}

  use {
    'hrsh7th/nvim-compe',
    requires = {
      {'hrsh7th/vim-vsnip'},
      {'hrsh7th/vim-vsnip-integ'}
    }
  }

  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'

  use 'justinmk/vim-sneak'

  use {'glepnir/galaxyline.nvim', branch = 'main'}

  use 'sheerun/vim-polyglot'

  use {'styled-components/vim-styled-components', branch = 'main'}

  -- use {
  --   'tjdevries/colorbuddy.nvim',
  --   requires = {
  --     {'Th3Whit3Wolf/onebuddy', branch = 'main'}
  --   }
  -- }

  use {
    'npxbr/gruvbox.nvim',
    requires = {
      {'rktjmp/lush.nvim', branch = 'main'}
    }
  }

  use 'google/vim-searchindex'
  use 'norcalli/snippets.nvim'
  use 'norcalli/ui.nvim'

  use 'kyazdani42/nvim-web-devicons'
end)
