local utils = require('utils')

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
