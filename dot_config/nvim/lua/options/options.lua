local set_vim_option = require "utils".set_vim_option

set_vim_option('completeopt', { "menuone", "noselect" })
set_vim_option('ignorecase', true)
set_vim_option('showmode', false)
set_vim_option('splitright', true)
set_vim_option('wrap', false)
set_vim_option('number', true)
set_vim_option('expandtab', true)
set_vim_option('showmode', false)
set_vim_option('undofile', true)
set_vim_option('incsearch', true)
-- Make searches case-insensitive, unless you include a capital letter in the search pattern
set_vim_option('ignorecase', true)
set_vim_option('smartcase', true)
set_vim_option('laststatus', 3)

vim.o.updatetime = 300
vim.g.mapleader = " " -- change leader key
-- vim.cmd('cabbrev h vert h')

-- Necessary for feline
vim.cmd('set termguicolors')
