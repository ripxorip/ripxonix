local utils = require('utils')
local cmd = vim.cmd

utils.opt('o', 'termguicolors', true)
utils.opt('o', 'background', 'dark')
cmd 'colorscheme onedark'

vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

vim.cmd [[colorscheme catppuccin]]
