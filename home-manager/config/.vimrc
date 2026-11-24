:imap jk <Esc>
:set number

colorscheme tokyonight-night

" Never insert line breaks automatically while typing. Filetype plugins set
" textwidth and formatoptions per buffer, so override them after they load.
:set textwidth=0 formatoptions-=t formatoptions-=c
:autocmd FileType * setlocal textwidth=0 formatoptions-=t formatoptions-=c
