local keymap = require('utils').keymap
local opts = require('utils').keymap_opts

-- remap escaping in terminal mode to escape
keymap('t', '<Esc>', '<C-\\><C-n>', opts)

keymap('i', 'kj', '<Esc>', opts)
keymap('i', 'jk', '<Esc>', opts)
keymap('n', '<Space>', '<C-w>', opts)

keymap('n', '0', '^', opts)
keymap('n', '^', '0', opts)
