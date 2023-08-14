" SPECIAL FILETYPES
" ##################################
autocmd FileType javascript setlocal ts=2 sts=2 sw=2
au BufRead,BufNewFile sconstruct set filetype=python
au BufRead,BufNewFile sconscript set filetype=python

set diffopt+=iwhite
set mouse=a
set noswapfile

autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

"autocmd BufWritePre *.tsx Neoformat
"autocmd BufWritePre *.js Neoformat
"autocmd BufWritePre *.ts Neoformat

autocmd FileType vim_tc_input let g:compe = {} | let g:compe.enabled = v:false | call compe#setup(g:compe, 0)

set number
set rnu

imap <c-x><c-x> <plug>(fzf-complete-path)
" Search ergonomics
vnoremap \\ y:Rg "<C-R>""<CR>
nnoremap \ :Rg<SPACE>
nnoremap \\ :Rg<CR>
