local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

vim.cmd('cabbrev h vert h')

keymap('i', 'kj', '<Esc>', opts)
keymap('i', 'jk', '<Esc>', opts)

keymap('n', '<Space>', '<C-w>', opts)

keymap('t', '<Esc>', '<C-\\><C-n>', opts)

