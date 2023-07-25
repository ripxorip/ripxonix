-- Map leader to space
vim.g.mapleader = ','

-- Configure packer
local fn = vim.fn
local execute = vim.api.nvim_command


--[[ local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end
 ]]
--vim.cmd [[packadd packer.nvim]]
--vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

-- Sensible defaults
require('settings')

-- Install plugins
-- require('plugins')

-- My custom lua scripts
require('ripxorip')

-- Key mappings
require('keymappings')

-- LSP
require('lang')

-- DAP
-- require('dbg')

-- Another option is to groups configuration in one folder
require('config')

-- OR you can invoke them individually here
-- require('config.colorscheme')  -- color scheme
-- require('config.completion')   -- completion
-- require('config.fugitive')     -- fugitive
