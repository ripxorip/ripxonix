-- ==========================================
-- ================ Utils
-- ==========================================
local utils = {}

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

function utils.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

function utils.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function utils.create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command('augroup ' .. group_name)
        vim.api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command('augroup END')
    end
end


-- ==========================================
-- ================ Settings
-- ==========================================

-- Map leader to space
vim.g.mapleader = ','

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

wo.cursorline = true
wo.wrap = false
o.number = true;
o.relativenumber = true;

vim.opt.diffopt:append('iwhite')
o.mouse = 'n'
o.swapfile = false

-- Convert autocmds to Lua
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"sconstruct", "sconscript"},
    command = "set filetype=python"
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "javascript",
    command = "setlocal ts=2 sts=2 sw=2"
})

vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
    pattern = "*",
    command = "if mode() != 'c' | checktime | endif"
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",
    command = [[echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]]
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "vim_tc_input",
    command = [[let g:compe = {} | let g:compe.enabled = v:false | call compe#setup(g:compe, 0)]]
})



-- ==========================================
-- ================ Custom Scripts
-- ==========================================

local a = vim.api;

function CloseFcnCall()
    a.nvim_input("$a;<Esc>");
end

function CloseFcnDeclaration()
    a.nvim_input("$<Esc>o{<CR>");
end

function JumpNextClosed()
    a.nvim_input("<Esc>la ");
end

function JumpNextClosedString()
    a.nvim_input("<Esc>la, ");
end


-- ==========================================
-- ================ Key Mappings
-- ==========================================

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

utils.map('n', '<Leader>gs', '<cmd>Git<CR>')
utils.map('n', '<Leader>gp', '<cmd>Git push<CR>')
utils.map('n', '<Leader>gb', '<cmd>GBranches<CR>')
utils.map('n', '<Leader>gd', '<cmd>Gvdiffsplit<CR>')
utils.map('n', '<Leader>gf', '<cmd>Fit fetch --all<CR>')
utils.map('n', '<Leader>grum', '<cmd>Git rebase upstream/master<CR>')  
utils.map('n', '<Leader>grom', '<cmd>Git rebase origin/master<CR>') 
utils.map('n', '<Leader>gdr', '<cmd>diffget //3<CR>') 
utils.map('n', '<Leader>gdl', '<cmd>diffget //2<CR>') 
utils.map('n', '<leader>gdb', '<cmd>lua require("config.telescope").git_branches()<CR>')

-- Copy to clipboard
utils.map('v', '<leader>y', '"+y')
utils.map('n', '<leader>Y', '"+yg_')
utils.map('n', '<leader>y', '"+y')
utils.map('n', '<leader>yy', '"+yy')

-- Paste from clipboard
utils.map('n', '<leader>p', '"+p')
utils.map('n', '<leader>P', '"+P')
utils.map('v', '<leader>p', '"+p')
utils.map('v', '<leader>P', '"+P')

-- Copilot Chat Commands
utils.map('n', '<Leader>aa', ':CopilotChat <CR>')
utils.map('n', '<Leader>at', ':CopilotChatToggle <CR>')
utils.map('n', '<Leader>ae', ':CopilotChatExplain <CR>')
utils.map('n', '<Leader>ar', ':CopilotChatReview <CR>')
utils.map('n', '<Leader>af', ':CopilotChatFix <CR>')
utils.map('v', '<Leader>aa', ':CopilotChat <CR>')
utils.map('v', '<Leader>at', ':CopilotChatToggle <CR>')
utils.map('v', '<Leader>ae', ':CopilotChatExplain <CR>')
utils.map('v', '<Leader>ar', ':CopilotChatReview <CR>')
utils.map('v', '<Leader>af', ':CopilotChatFix <CR>')


-- New ripgrep bindings
utils.map('n', '<leader>re', ':Rg<CR>')
utils.map('n', '<leader>rr', ':Rg <CR>')
utils.map('n', '<leader>rc', ':Rgc <CR>')
utils.map('n', '<leader>rs', ':Rgi <CR>')

utils.map('i', '<C-o>', '<ESC>:lua CloseFcnCall() <CR>')
utils.map('i', '<C-e>', '<ESC>:lua CloseFcnDeclaration() <CR>')
utils.map('i', '<C-s>', '<ESC>:lua JumpNextClosedString() <CR>')
utils.map('i', '<C-t>', '<ESC>:lua JumpNextClosed() <CR>')

utils.map('i', '<C-t>', '<ESC>:lua JumpNextClosed() <CR>')

utils.map('i', '<c-x><c-x>', '<plug>(fzf-complete-path)')
utils.map('v', '\\', 'y:Rg "<C-R>""<CR>')
utils.map('n', '\\', ':Rg<SPACE>')
utils.map('n', '\\\\', ':Rg<CR>')

utils.map('n', '<leader>vv', ':e ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })

utils.map('n', '<leader>.,', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
utils.map('n', '<leader>..', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
utils.map('n', '<leader>t', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
utils.map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
utils.map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
utils.map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
utils.map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
utils.map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
utils.map('n', '<leader>law', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
utils.map('n', '<leader>lrw', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
utils.map('n', '<leader>llw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
utils.map('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
utils.map('n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
utils.map('n', '<leader>.r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
utils.map('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
utils.map('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
utils.map('n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

-- ==========================================
-- ================ Colorscheme
-- ==========================================
local cmd = vim.cmd
utils.opt('o', 'termguicolors', true)
utils.opt('o', 'background', 'dark')
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
require("catppuccin").setup()
vim.cmd [[colorscheme catppuccin]]

-- ==========================================
-- ================ LSP
-- ==========================================
local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Code actions
capabilities.textDocument.codeAction = {
    -- dynamicRegistration = true
    dynamicRegistration = false,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = (function()
                local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                table.sort(res)
                return res
            end)()
        }
    }
}

capabilities.textDocument.completion.completionItem.snippetSupport = true;

-- LSPs
nvim_lsp.ccls.setup{
    init_options = {
        cache = {
            directory = "/home/ripxorip/.cache/ccls"
        };
    };
    root_dir = nvim_lsp.util.root_pattern('compile_commands.json');
    capabilities = capabilities;
    on_attach = on_attach
}

require'lspconfig'.tsserver.setup{on_attach=on_attach}
require'lspconfig'.pylsp.setup{on_attach=on_attach, cmd={"pylsp"}}
require'lspconfig'.rust_analyzer.setup{on_attach=on_attach}


-- ==========================================
-- ================ cmp
-- ==========================================
-- Set up nvim-cmp.
local cmp = require'cmp'

require("luasnip/loaders/from_vscode").lazy_load()

local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-O>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-N>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, {silent = true})

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    })
})


-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['ccls'].setup {
    capabilities = capabilities
}

-- ==========================================
-- ================ Tmux
-- ==========================================
vim.api.nvim_exec([[
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <c-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <c-Right> :TmuxNavigateRight<cr>
]], false)


-- ==========================================
-- ================ Autopairs
-- ==========================================
require('nvim-autopairs').setup()
local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

-- skip it, if you use another global object
_G.MUtils= {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end


remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})


-- ==========================================
-- ================ Treesitter
-- ==========================================

require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},              -- list of language that will be disabled
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false -- Whether the query persists across vim sessions
  },
  rainbow = {
    enable = true
  }
}


-- ==========================================
-- ================ LLM/AI/Codegen
-- ==========================================

require('copilot').setup()
require("CopilotChat").setup ()
require("copilot_cmp").setup()
require("chatgpt").setup({
    api_key_cmd = "cat /home/ripxorip/.secret/openai"
})

-- ==========================================
-- ================ Misc plugins
-- ==========================================
require('gitsigns').setup()
