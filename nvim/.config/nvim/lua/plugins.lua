vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'}
    }
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {
      {'glepnir/lspsaga.nvim', branch = 'main'}
    }
  }

  use {
    'hrsh7th/nvim-compe',
    requires = {
      {'hrsh7th/vim-vsnip'},
      {'hrsh7th/vim-vsnip-integ'}
    }
  }

  use {'tpope/vim-commentary'}
  use {'tpope/vim-surround'}

  use {'justinmk/vim-sneak'}

  use {'bluz71/vim-moonfly-statusline'}

  use {'jnurmine/Zenburn'}

  use {'sheerun/vim-polyglot'}

  use {'styled-components/vim-styled-components', branch = 'main'}

  use {'ms-jpq/chadtree', branch = 'chad'}
end)
