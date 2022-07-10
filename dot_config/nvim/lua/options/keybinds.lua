local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- remap escaping in terminal mode to escape
keymap('t', '<Esc>', '<C-\\><C-n>', opts)

keymap('i', 'kj', '<Esc>', opts)
keymap('i', 'jk', '<Esc>', opts)
keymap('n', '<Space>', '<C-w>', opts)
