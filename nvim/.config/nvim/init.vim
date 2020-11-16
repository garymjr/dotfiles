if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

scriptencoding utf-8
filetype plugin indent on

if exists('g:vscode')
  call plug#begin('~/.local/share/nvim/site/plugged')
    Plug 'asvetliakov/vim-easymotion'
    Plug 'tpope/vim-surround'
  call plug#end()

  xmap gc  <Plug>VSCodeCommentary
  vmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
  nnoremap <silent> K <Cmd>call VSCodeCall('editor.action.showHover')<cr>
  nnoremap <silent> gr <Cmd>call VSCodeCall('references-view.find')<cr>
  nnoremap <silent> - <Cmd>call VSCodeCall('workbench.files.action.showActiveFileInExplorer')<cr>
  nnoremap <silent> <space> <Cmd>call VSCodeCall('whichkey.show')<cr>
  nnoremap <silent> <tab> <Cmd>call VSCodeCall('workbench.action.nextEditor')<cr>
  nnoremap <silent> <s-tab> <Cmd>call VSCodeCall('workbench.action.previousEditor')<cr>
  nnoremap <silent> <c-h> <Cmd>call VSCodeCall('workbench.action.navigateLeft')<cr>
  nnoremap <silent> <c-j> <Cmd>call VSCodeCall('workbench.action.navigateDown')<cr>
  nnoremap <silent> <c-k> <Cmd>call VSCodeCall('workbench.action.navigateUp')<cr>
  nnoremap <silent> <c-l> <Cmd>call VSCodeCall('workbench.action.navigateRight')<cr>

  nmap s <Plug>(easymotion-s2)
  vmap < <gv
  vmap > >gv
  finish
endif

let mapleader = ' '

call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'

Plug 'justinmk/vim-sneak'
Plug 'justinmk/vim-dirvish'

Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-statusline'

Plug 'SirVer/ultisnips'
Plug 'voldikss/vim-floaterm'
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'psliwka/vim-smoothie'
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

colorscheme nightfly

hi! link GitLens Comment

let g:UltiSnipsSnippetDirectories = ['ultisnips']
let g:completion_enable_snippet = 'UltiSnips'

let g:floaterm_wintitle = v:false
let g:floaterm_autoclose = v:true

inoremap <silent><expr> <tab>
      \ pumvisible() ? coc#select_confirm() :
      \ coc#expandableOrJumpable() ? "\<c-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<c-r>" :
      \ <SID>check_back_space() ? "\<tab>" :
      \ coc#refresh()

inoremap <silent><expr> <c-j> pumvisible() ? "\<c-n>" : "\<c-j>"
inoremap <silent><expr> <c-k> pumvisible() ? "\<c-p>" : "\<c-k>"

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
command! Prettier CocCommand prettier.formatFile

vmap < <gv
vmap > >gv

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

" use escape in terminal
tnoremap <esc> <c-\><c-n>


" Keep visual selection when shifting

