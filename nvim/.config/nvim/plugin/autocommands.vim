augroup startup
	autocmd!

	" when in a neovim terminal, add a buffer to the existing vim session
	" instead of nesting (credit justinmk)
	autocmd VimEnter * if !empty($NVIM_LISTEN_ADDRESS) && $NVIM_LISTEN_ADDRESS !=# v:servername
		\ |let g:r=jobstart(['nc', '-U', $NVIM_LISTEN_ADDRESS],{'rpc':v:true})
		\ |let g:f=fnameescape(expand('%:p'))
		\ |noau bwipe
		\ |call rpcrequest(g:r, "nvim_command", "edit ".g:f)
		\ |qa
		\ |endif
augroup END
