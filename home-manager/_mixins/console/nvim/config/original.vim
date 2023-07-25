" PLATFORM SPECIFIC PRECONDS
" ##################################
if has("win32")
  let g:python3_host_prog  = 'C:\Python3\python.exe'
  call plug#begin('C:/Temp/Plugins')
elseif has("macunix")
  call plug#begin('~/dev/VimPlugs')
else
  let g:python3_host_prog  = 'python3'
  call plug#begin('~/dev/VimPlugs')
endif









" PLUGIN BEGIN
" ##################################
Plug 'ctrlpvim/ctrlp.vim'
Plug 'pangloss/vim-javascript'
Plug 'rhysd/vim-clang-format'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-unimpaired'
Plug 'ripxorip/bolt.nvim'
Plug 'ripxorip/utils.nvim'
Plug 'ripxorip/ccflags.nvim'
Plug 'ripxorip/aerojump.nvim'
Plug 'ripxorip/r2.nvim'
Plug 'chrisbra/Colorizer'
" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'NLKNguyen/papercolor-theme'
Plug 'overcache/NeoSolarized'
Plug 'ripxorip/gruvbox'
Plug 'crusoexia/vim-monokai'
Plug 'nanotech/jellybeans.vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
""""""""""""""""""""
Plug 'gcmt/taboo.vim'
Plug 'ripxorip/nvgdb.nvim'
Plug 'sgeb/vim-diff-fold'
Plug 'mhinz/vim-signify'
Plug 'vimwiki/vimwiki'
Plug 'sirtaj/vim-openscad'
Plug 'christoomey/vim-tmux-navigator'
if !empty($USE_COC)
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
if has("win32")
elseif has("mac") || has("macunix")
  " Brew install fzf
  Plug '/usr/local/opt/fzf'
  Plug '~/dev/VimPlugs/ScpSync/'
  Plug 'philip-karlsson/midi.nvim'
else
  " Linux prototype plugins
  Plug '~/dev/PluginPrototypes/GetCCFlags.nvim'
endif
" Finalize plugin installation
call plug#end()








" VIM SETTINGS
" ##################################
if has("win32")
    language en_US
endif
imap ii <esc>
set cursorline
nmap <Space> /
nmap <C-Space> ?
cnoremap ii <CR> h
" noremap ; :
" noremap ;; ;
set copyindent
set autoindent
set history=1000
set undolevels=1000
set hidden
set nohlsearch
set number
set rnu
set nowrap
set cindent
set shiftwidth=4
set expandtab
set list
set ignorecase
set smartcase
set diffopt+=iwhite
set mouse=n
set noswapfile
colorscheme pablo
" rnu color
highlight LineNr ctermfg=grey






"
" THEME SETTINGS
" ##################################
set background=dark
set termguicolors
colorscheme onehalfdark
let g:airline_powerline_fonts = 1










" VIM AUTOCOMMANDS
" ##################################
" This one is to be able to reload file if it has changed automatically
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None










" PLUGIN SETTINGS
" ##################################
" Vimwiki
let g:vimwiki_list = [{'path': '~/dev/wiki'}]
let g:nvimgdb_disable_start_keymaps = 1
if has("win32")
    source C:/devtools/fzf.vim
endif
if !empty(glob("/usr/share/doc/fzf/examples/fzf.vim"))
    source /usr/share/doc/fzf/examples/fzf.vim
endif
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
if !empty($USE_COC)
    source ~/.dot/nvim/coc_settings.vim
endif





" SPECIAL FILETYPES
" ##################################
au BufRead,BufNewFile sconstruct set filetype=python
au BufRead,BufNewFile sconscript set filetype=python
autocmd FileType javascript setlocal ts=2 sts=2 sw=2







" TMUX NAVIGATOR BINGINGS
" ##################################
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <c-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <c-Right> :TmuxNavigateRight<cr>







" MAPPINGS
" ##################################
nnoremap <c-q> :CtrlPBuffer <CR>
let mapleader = ","
nmap <Leader>ss :Bolt <CR>
nmap <Leader>sS :BoltCwd <CR>
" Aerojump mappings
nmap <Leader>al <Plug>(AerojumpFromCursorBolt)
nmap <Leader>as <Plug>(AerojumpSpace)
nmap <Leader>. <Plug>(AerojumpSpace)
nmap <Leader>aa <Plug>(AerojumpBolt)
nmap <leader>al <Plug>(AerojumpShowLog)
nmap <Leader><Space> <Plug>(AerojumpBolt)

" QMK mappings
nmap <leader>qq :e /home/ripxorip/dev/qmk_firmware/keyboards/handwired/dactyl_manuform/5x6/keymaps/ripxorip/keymap.c <CR>

" Gdb mappings
nmap <Leader>ds <Plug>(NvGdbStart)
nmap <Leader>dl <Plug>(NvGdbShowLog)
nmap <F8> <Plug>(NvGdbToggleBreakpoint)
nmap <F5> <Plug>(NvGdbResume)
nmap <F10> <Plug>(NvGdbStepOver)
nmap <F11> <Plug>(NvGdbSingleStep)
nmap <Leader>dj <Plug>(NvGdbStop)
nmap <Leader>dr <Plug>(NvGdbReset)
nmap <Leader>db <Plug>(NvGdbRefreshBreakpoints)
nmap <Leader>de <Plug>(NvGdbEvalWord)
nmap <Leader>dt <Plug>(NvGdbShowStackTrace)
" Bind fzf to c-t
nnoremap <c-t> :FZF <CR>
nnoremap <leader>cc :Colors <CR>
nnoremap <leader>cr :set rnu! <CR>
nnoremap <leader>ct :set termguicolors! <CR>
nnoremap <leader>cd :set background=dark <CR>
nnoremap <leader>cl :set background=light <CR>
nnoremap <leader>cf :ClangFormat <CR>
" Find replace maps
nmap <leader>er :UtilsFindReplaceRecursive <CR>
nmap <leader>ef :UtilsFindReplaceInFile <CR>
nmap <leader>ei :UtilsFindReplaceInFileIncremental <CR>
" New ripgrep bindings
nmap <leader>re :Rg <CR>
nmap <leader>rr :Rg
" Special for assignment at HQ
nmap <leader>rcc :Rgc <CR>
nmap <leader>rcv :Rgc
nmap <Leader>, :w<CR>
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gd :Gvdiffsplit<CR>
nmap <Leader>ga :GV --all<CR>
nmap <Leader>dd :bp\|bd #<CR>
" Map tmux yank and paste
" Fast terminal split
" nmap <Leader>tt :spl<CR><C-j>:te<CR>i
" Map to highlight
nmap <Leader>hh :History:<CR>
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy
" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
" Yank current file and line to clipboard (awesome)
nnoremap  <leader>uu  :YankLineAndFileToClipboard <cr>
" This is just a test to see if I can make search more like emacs
nnoremap <c-s> :set hlsearch! <CR>
noremap <c-e> ?
cnoremap <c-s> <c-g>
cnoremap <c-d> <esc>
tnoremap <leader>j <C-\><C-n>
tnoremap <leader>t <C-\><C-n> :tabprevious<CR>
nmap <Leader>tn :tabnew<CR>
" Always go to terminal which is in the first tab
nnoremap <leader>tt 2gt<CR>i
nnoremap <leader>tr :tabprevious<CR>
nnoremap <leader>t, :TabooRename 
nnoremap <leader>tl :tabnew<CR>:TabooRename term<CR>:te<CR>i
nnoremap <Leader>t0 1gt
nnoremap <leader>t1 2gt
nnoremap <leader>t2 3gt
nnoremap <leader>t3 4gt
nnoremap <leader>t4 5gt
nnoremap <leader>t5 6gt
nnoremap <leader>t6 7gt
nnoremap <leader>t7 8gt
nnoremap <leader>t8 9gt
nnoremap <leader>t9 10gt
