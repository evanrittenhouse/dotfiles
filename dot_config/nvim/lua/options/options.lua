vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.ignorecase = true
vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.showmode = false
vim.opt.undofile = true
vim.o.updatetime = 300
vim.opt.incsearch = true
vim.g.mapleader = " " -- change leader key

-- Make searches case-insensitive, unless you include a capital letter in the search pattern
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.cmd('cabbrev h vert h')
vim.cmd('set termguicolors')
