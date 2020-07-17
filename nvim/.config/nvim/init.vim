if exists('g:vscode')
  xmap gc  <Plug>VSCodeCommentary
  vmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
  nnoremap <silent> K <Cmd>call VSCodeCall('editor.action.showHover')<CR>
  nnoremap <silent> <TAB> <Cmd>call VSCodeCall('workbench.action.showAllEditors')<CR>
  nnoremap <silent> gr <Cmd>call VSCodeCall('references-view.find')<CR>
  nnoremap <silent> - <Cmd>call VSCodeCall('workbench.files.action.showActiveFileInExplorer')<CR>
  finish
endif

scriptencoding utf-8
filetype plugin indent on

syntax enable
syntax on

let mapleader=' '

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'SirVer/ultisnips'
Plug 'voldikss/vim-floaterm'

Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'ntpeters/vim-better-whitespace'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

Plug 'ntk148v/vim-horizon'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/edge'

Plug 'psliwka/vim-smoothie'
Plug 'justinmk/vim-sneak'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
call plug#end()

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
set guifont=Dank\ Mono:h18
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
set updatetime=1000
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*/node_modules/*
set wildmenu
set wildmode=list:longest,list:full

augroup auto_update_files
  autocmd!
  autocmd FocusGained,WinEnter * checktime
augroup END

augroup sync_colors
  autocmd!
  autocmd BufEnter,BufWrite * syntax sync fromstart
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
  autocmd InsertEnter,WinLeave,BufLeave * :setlocal nocursorline
  autocmd InsertLeave,WinEnter,BufEnter * :setlocal cursorline
augroup END

colorscheme edge

hi! link GitLens Comment

let g:airline_theme = 'edge'
" let g:airline_powerline_fonts = 1
" let g:airline_left_sep = "\ue0b8"
" let g:airline_right_sep = "\ue0be"

let g:tmuxline_separators = {
      \ 'left': '',
      \ 'left_alt': '',
      \ 'right': '',
      \ 'right_alt': '',
      \ 'space': ' ',
      \ }

let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

let g:UltiSnipsSnippetDirectories = ['ultisnips']
let g:completion_enable_snippet = 'UltiSnips'

let g:startify_change_to_dir = 0

let g:edge_enable_italic = 1

let g:floaterm_wintitle = v:false
let g:floaterm_autoclose = v:true

inoremap <silent><expr> <tab>
      \ pumvisible() ? coc#select_confirm() :
      \ coc#expandableOrJumpable() ? "\<c-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<c-r>" :
      \ <SID>check_back_space() ? "\<tab>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

command! Lazygit FloatermNew --height=0.9 --width=0.9 lazygit
nnoremap <leader>g :Lazygit<cr>

command! GBlame lua require'git_lens'.blameVirtText()

" Make Y like P
nnoremap Y y$

" fzf
" nnoremap <silent> <tab> :Buffers<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>h :Helptags<cr>
nnoremap <silent> <backspace> :Buffers<cr>

" coc.nvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>e :CocCommand explorer<cr>

" Keep visual selection when shifting
vmap < <gv
vmap > >gv

nnoremap <leader>n :NnnPicker '%:p:h'<cr>
