function! ActiveStatusLine()
	return luaeval("require'modules.statusline'.active_statusline()")
endfunction

function! InActiveStatusLine()
	return luaeval("require'modules.statusline'.inactive_statusline()")
endfunction

augroup StatusLine
	autocmd!
	autocmd BufEnter,WinEnter * setlocal statusline=%!ActiveStatusLine()
	autocmd BufLeave,WinLeave * setlocal statusline=%!InActiveStatusLine()
augroup END
