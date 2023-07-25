--local utils = require('utils')


vim.api.nvim_exec([[
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <c-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <c-Right> :TmuxNavigateRight<cr>
]], false)
