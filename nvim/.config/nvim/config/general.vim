set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set belloff=all
set clipboard^=unnamed,unnamedplus
set complete-=i
set complete-=t
set completeopt=menuone,noinsert,noselect
set encoding=utf-8
set expandtab
set foldmethod=indent
set foldlevelstart=99
set grepprg=rg\ --color=never
set fileformats=unix
set hidden
set history=10000
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set nobackup
set nohlsearch
set nomodeline
set noshowcmd
set noshowmode
set noswapfile
set noundofile
set nowrap
set number
set path+=**
set re=2
set ruler
set scrolloff=3 sidescrolloff=3
set shiftwidth=2
set shortmess+=I
set shortmess+=W
set shortmess+=a
set shortmess+=c
set signcolumn=no
set smartcase
set splitbelow
set splitright
set tabstop=2
set termguicolors
set timeoutlen=1000 ttimeoutlen=0
set updatetime=300
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*/node_modules/*
set wildmenu
set wildmode=list:longest,list:full

augroup auto_update_files
  autocmd!
  autocmd CursorHold,FocusGained,WinEnter * checktime
augroup END

augroup sync_colors
  autocmd!
  autocmd BufEnter,BufWrite,CursorHold * syntax sync fromstart
augroup END

augroup remember_last_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup quickfix_on_bottom
  autocmd!
  autocmd FileType qf wincmd J
augroup END

augroup neovim_terminal
  autocmd!
  autocmd TermOpen * :setlocal nonumber norelativenumber
augroup END

augroup insert_cursorline
  autocmd!
  autocmd InsertEnter,WinLeave * :setlocal nocursorline
  autocmd InsertLeave,WinEnter * :setlocal cursorline
augroup END

colorscheme sonokai
