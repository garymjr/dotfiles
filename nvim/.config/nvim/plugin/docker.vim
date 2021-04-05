function! Docker(...) abort
	let cmd = join(a:000, ' ')
	execute('term docker '.cmd)
endfunction

command! -nargs=+ Docker call Docker(<f-args>)
