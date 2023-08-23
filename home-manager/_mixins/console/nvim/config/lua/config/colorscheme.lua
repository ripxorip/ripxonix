local utils = require('utils')
local cmd = vim.cmd

--utils.opt('o', 'termguicolors', true)
--utils.opt('o', 'background', 'dark')
-- cmd 'colorscheme onedark'

-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

require('github-theme').setup({
    options = {
        hide_nc_statusline = false,

    },
})

vim.cmd [[colorscheme github_light]]
vim.cmd ('set laststatus=0')
-- vim.cmd('colorscheme github_light')
