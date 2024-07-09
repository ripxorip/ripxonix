-- Map leader to space
vim.g.mapleader = ','

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

require('gitsigns').setup()

require('copilot').setup()
require("CopilotChat").setup ()
require("chatgpt").setup({
    api_key_cmd = "cat /home/ripxorip/.secret/openai"
})

-- OR you can invoke them individually here
-- require('config.colorscheme')  -- color scheme
-- require('config.completion')   -- completion
-- require('config.fugitive')     -- fugitive
