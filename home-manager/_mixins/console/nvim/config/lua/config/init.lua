require('config.colorscheme')
require('config.fugitive')
-- require('config.devicon')
-- require('config.project')
-- require('config.telescope')

-- nvim-compe
require('config.compe')
require('config.tmux')
require('config.autopairs')

-- lspkind-nvim
-- require('config.lspkind')

-- nvim-colorizer
-- require('config.colorizer')

-- nvim-lightbulb
-- require('config.lightbulb')

-- treesitter
require('config.treesitter')

-- snippets.nvim
-- require('config.snippets')

-- completion-nvim
-- require('config.completion')

-- vim-slime
--require('config.slime')

vim.api.nvim_exec([[
let g:vimwiki_list = [{'path': '~/dev/wiki'}]
]], false)
