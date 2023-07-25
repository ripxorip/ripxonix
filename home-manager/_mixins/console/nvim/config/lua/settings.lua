local utils = require('utils')

local cmd = vim.cmd
local o = vim.o
local wo = vim.wo
local bo = vim.bo
local indent = 4

cmd 'syntax enable'
cmd 'filetype plugin indent on'

o.termguicolors = true
bo.expandtab = true
bo.shiftwidth = indent
bo.smartindent = true
bo.tabstop = indent

o.copyindent =  true
o.autoindent = true
o.history=1000
o.undolevels=1000
o.hidden =  true
o.hlsearch = false
o.wrap =  false
o.cindent = true
o.shiftwidth = 4
o.expandtab = true
o.list = true
o.ignorecase = true
o.smartcase = true
o.swapfile = false

-- wo.number = true
-- wo.relativenumber = true
wo.cursorline = true
wo.wrap = false

vim.api.nvim_exec([[
au BufRead,BufNewFile sconstruct set filetype=python
au BufRead,BufNewFile sconscript set filetype=python

set diffopt+=iwhite
set mouse=n
set noswapfile
set cmdheight=0


]], false)
