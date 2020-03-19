filetype off
packadd! vim-startify
packadd! fzf
packadd! fzf.vim
packadd! emmet-vim
packadd! vim-better-whitespace
packadd! vim-styled-components
packadd! traces.vim

packadd! vim-js
packadd! yats.vim
packadd! vim-jsx-pretty
packadd! html5.vim
packadd! vim-css3-syntax

packadd! vim-commentary
packadd! vim-eunuch
packadd! vim-surround

packadd! vim-airline
packadd! vim-airline-themes

packadd! srcery-vim

packadd! coc.nvim
packadd! coc-snippets
packadd! coc-emmet
packadd! coc-json
packadd! coc-tsserver
packadd! coc-html
packadd! coc-css
packadd! coc-prettier

filetype plugin indent on
syntax on

set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set belloff=all
set clipboard^=unnamed,unnamedplus
set complete-=i
set complete-=t
set completeopt=menu,menuone,noinsert,noselect
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

scriptencoding utf-8

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

filetype plugin indent on
colorscheme srcery

let g:airline_powerline_fonts = 1
let g:airline_left_sep = "\ue0b8"
let g:airline_right_sep = "\ue0be"

augroup AutoUpdateFiles
  autocmd!
  autocmd CursorHold,FocusGained,WinEnter * checktime
  autocmd BufEnter,BufWrite,CursorHold * syntax sync fromstart
augroup END

augroup RemeberLastPosition
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup Css
  autocmd!
  autocmd FileType css setlocal iskeyword+=-
augroup END

augroup QuickFix
  autocmd!
  autocmd FileType qf wincmd J
augroup END

let g:startify_change_to_dir = 0

let mapleader=' '

" Use esc to exit insert mode in terminal
tnoremap <esc> <c-\><c-n>

" Keep visual selection when shifting
vmap < <gv
vmap > >gv

" make backspace useful in normal mode
nnoremap <backspace> <c-^>

" Make Y like P
nnoremap Y y$

" emmet
inoremap <silent> <c-e> <c-r>=emmet#expandAbbr(0, "")<cr>

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <tab> :Buffers<cr>
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
nnoremap <silent> <leader>gf :GFiles<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <leader>h :Helptags<cr>
nnoremap <silent> <leader>lg :term ++close lazygit<cr>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
imap <C-l> <Plug>(coc-snippets-expand)
inoremap <silent><expr> <c-x><c-o> coc#refresh()
