local utils = require('utils')

-- utils.map('i', 'ii', '<Esc>') -- ii to escape
utils.map('n', '<C-s>', ':set hlsearch! <CR>')
utils.map('n', '<C-t>', ':Files <CR>')
utils.map('n', '<C-q>', ':Buffers <CR>')
utils.map('n', '<leader>cc', ':Commands <CR>')
utils.map('n', '<leader>ch', ':History: <CR>')
utils.map('n', '<leader>ct', ':checktime <CR>')
utils.map('n', '<leader>,', ':w<CR>')
utils.map('n', '<leader>s', ':Bolt <CR>')
utils.map('n', '<leader>ss', ':BoltCwd <CR>')
utils.map('n', '<leader>f', ':Neoformat <CR> :w<CR>')
utils.map('n', '<leader>cf', ':Neoformat <CR>')
utils.map('n', '<leader>qq', ':lprev <CR>')
utils.map('n', '<leader>qw', ':lnext <CR>')
utils.map('n', '<leader>gh', ':0Gllog <CR>')

vim.api.nvim_exec([[
nmap <Leader>dd :bp\|bd #<CR>

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

nmap <Leader>al <Plug>(AerojumpFromCursorBolt)
nmap <Leader>as <Plug>(AerojumpSpace)
nmap <Leader>aa <Plug>(AerojumpBolt)
nmap <leader>al <Plug>(AerojumpShowLog)
nmap <Leader><Space> <Plug>(AerojumpBolt)

" New ripgrep bindings
nmap <leader>re :Rg
nmap <leader>rr :Rg <CR> 
nmap <leader>rc :Rgc <CR>
nmap <leader>rs  :Rgi <CR>

]], false)
