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

]], false)


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

utils.map('i', '<C-o>', '<ESC>:lua CloseFcnCall() <CR>')
utils.map('i', '<C-e>', '<ESC>:lua CloseFcnDeclaration() <CR>')
utils.map('i', '<C-s>', '<ESC>:lua JumpNextClosedString() <CR>')
utils.map('i', '<C-t>', '<ESC>:lua JumpNextClosed() <CR>')


--[[
local buf = a.nvim_get_current_buf();
local bl = a.nvim_buf_get_lines(buf, 0, -1, false);
print(bl[3])
bl[3] = "hello world";
a.nvim_buf_set_lines(buf, 0, -1, false, bl);
]]

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

-- ==========================================
-- ================ Colorscheme
-- ==========================================
local cmd = vim.cmd

utils.opt('o', 'termguicolors', true)
utils.opt('o', 'background', 'dark')
-- cmd 'colorscheme onedark'

vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

vim.cmd [[colorscheme catppuccin]]

-- ==========================================
-- ================ LSP
-- ==========================================

local on_attach = function(client, bufnr)

    -- require('completion').on_attach()
    -- require 'illuminate'.on_attach(client)
    -- require 'lsp_signature'.on_attach(client)

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}
    buf_set_keymap('n', '<leader>.,', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>..', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>t', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',opts)
    buf_set_keymap('n', '<leader>law','<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>lrw','<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>llw','<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',opts)
    buf_set_keymap('n', '<leader>lt','<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>.r', '<cmd>lua vim.lsp.buf.references()<CR>',opts)
    buf_set_keymap('n', '<leader>ld','<cmd>lua vim.diagnostic.open_float()<CR>',opts)
    buf_set_keymap('n', '<leader>ll','<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>',opts)

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf","<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>lf","<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false
        }
    )

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- require'snippets'.use_suggested_mappings(true) -- for snippets.vim

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
    -- codeActionLiteralSupport = {
    --     codeActionKind = {
    --         valueSet = {
    --             "", "quickfix", "refactor", "refactor.extract",
    --             "refactor.inline", "refactor.rewrite", "source",
    --             "source.organizeImports"
    --         }
    --     }
    -- }
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

-- require'lspinstall'.setup()
-- local servers = require'lspinstall'.installed_servers()
--[[
local servers = {"ccls"}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach
        -- init_options = {
        --     onlyAnalyzeProjectsWithOpenFiles = true,
        --     suggestFromUnimportedLibraries = false,
        --     closingLabels = true,
        -- };
    }
end
]]

-- Lua LSP. NOTE: This replaces the calls where you would have before done `require('nvim_lsp').sumneko_lua.setup()`
-- require('nlua.lsp.nvim').setup(require('lspconfig'), {
--     capabilities = capabilities,
--     on_attach = on_attach
    -- init_options = {
    --     onlyAnalyzeProjectsWithOpenFiles = true,
    --     suggestFromUnimportedLibraries = false,
    --     closingLabels = true
    -- }
-- })

-- ==========================================
-- ================ Compe
-- ==========================================

vim.cmd [[set shortmess+=c]]
vim.o.completeopt = 'menuone,noselect'

require'compe'.setup {
    enabled = true,
    autocomplete = false,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        calc = true,
        vsnip = true,
        nvim_lsp = true,
        nvim_lua = true,
        spell = true,
        tags = true,
        snippets_nvim = true,
        treesitter = true,
        vim_dadbod_completion = true
    }
}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
--[[
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

utils.map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
utils.map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
utils.map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
utils.map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
]]

vim.api.nvim_exec([[
inoremap <silent><expr> <C-Space> compe#complete()
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
]], false)


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
require("chatgpt").setup({
    api_key_cmd = "cat /home/ripxorip/.secret/openai"
})

-- ==========================================
-- ================ Misc plugins
-- ==========================================
require('gitsigns').setup()