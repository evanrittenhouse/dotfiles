local set_vim_option = require "utils".set_vim_option

-- Change leader key
vim.g.mapleader = " "

set_vim_option('completeopt', { "menuone", "noselect" })
-- Disable printing the mode, since it's already in Feline
set_vim_option('showmode', false)
-- Split tabs to the right
set_vim_option('splitright', true)
-- Don't wrap lines
set_vim_option('wrap', false)
set_vim_option('number', true)
set_vim_option('expandtab', true)
set_vim_option('undofile', true)
set_vim_option('incsearch', true)
-- Make searches case-insensitive, unless you include a capital letter in the search pattern
set_vim_option('ignorecase', true)
set_vim_option('smartcase', true)
-- Global statusline
set_vim_option('laststatus', 3)
-- Write to the swap file if nothing's been written in X miliseconds
set_vim_option('updatetime', 300)

-- Necessary for feline
vim.cmd('set termguicolors')
