function! vsnip_integ#auto_expand() abort
  if g:vsnip_integ_config.auto_expand
    call vsnip_integ#auto_expand#enable()
  endif
endfunction

function! vsnip_integ#vim_lsp() abort
  if g:vsnip_integ_config.vim_lsp && s:exists('autoload/lsp.vim')
    call vsnip_integ#vim_lsp#enable()
  endif
endfunction

function! vsnip_integ#vim_lsc() abort
  if g:vsnip_integ_config.vim_lsc && s:exists('plugin/lsc.vim')
    call vsnip_integ#vim_lsc#enable()
  endif
endfunction

function! vsnip_integ#lamp() abort
  if g:vsnip_integ_config.lamp && s:exists('autoload/lamp.vim')
    call vsnip_integ#lamp#enable()
  endif
endfunction

function! vsnip_integ#deoplete_lsp() abort
  try
    if g:vsnip_integ_config.deoplete_lsp && has('nvim') && luaeval('require("deoplete").request_candidates ~= nil')
      call vsnip_integ#deoplete_lsp#enable()
    endif
  catch /.*/
  endtry
endfunction

function! vsnip_integ#nvim_lsp() abort
  if g:vsnip_integ_config.nvim_lsp && s:exists('lua/vim/lsp.lua')
    call vsnip_integ#nvim_lsp#enable()
  endif
endfunction

function! vsnip_integ#language_client_neovim() abort
  if g:vsnip_integ_config.language_client_neovim && s:exists('autoload/LanguageClient.vim')
    call vsnip_integ#language_client_neovim#enable()
  endif
endfunction


function! vsnip_integ#asyncomplete() abort
  if g:vsnip_integ_config.asyncomplete && s:exists('autoload/asyncomplete.vim')
    call vsnip_integ#asyncomplete#enable()
  endif
endfunction

function! vsnip_integ#mucomplete() abort
  if g:vsnip_integ_config.mucomplete && s:exists('autoload/mucomplete.vim')
    call vsnip_integ#mucomplete#enable()
  endif
endfunction

function! vsnip_integ#compete() abort
  if g:vsnip_integ_config.compete && s:exists('autoload/compete.vim')
    call vsnip_integ#compete#enable()
  endif
endfunction

function! s:exists(filepath) abort
  return !empty(globpath(&runtimepath, a:filepath))
endfunction

