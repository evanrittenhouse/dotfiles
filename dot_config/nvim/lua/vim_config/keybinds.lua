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

-- move highlighted lines together
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- keep cursor in current position when appending with `J`
keymap("n", "J", "mzJ`z", opts)

-- Center <C-d>, <C-u>
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Copy to system clipboard
keymap("n", "<leader>y", "\"+y", opts)
keymap("n", "<leader>Y", "\"+Y", opts)
keymap("v", "<leader>y", "\"+y", opts)
