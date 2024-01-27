local keymap = require('utils').keymap
local opts = require('utils').keymap_opts

-- remap escaping in terminal mode to escape
keymap('t', '<Esc>', '<C-\\><C-n>', opts)

keymap('i', 'kj', '<Esc>', opts)
keymap('i', 'jk', '<Esc>', opts)
keymap('n', '<Space>', '<C-w>', opts)

-- center search results when cycling through them
keymap('n', 'n', 'nzz', opts)
keymap('n', 'N', 'Nzz', opts)

-- clear search highlight when you hit escape
keymap('n', '<ESC>', ':nohlsearch<Bar>:echo<CR>', opts)
