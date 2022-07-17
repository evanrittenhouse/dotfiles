local keymap = require('utils').keymap
local opts = require('utils').keymap_opts

-- remap escaping in terminal mode to escape
keymap('t', '<Esc>', '<C-\\><C-n>', opts)

keymap('i', 'kj', '<Esc>', opts)
keymap('i', 'jk', '<Esc>', opts)
keymap('n', '<Space>', '<C-w>', opts)

-- PLUGIN KEYMAPPINGS --
keymap('n', 's', '<Plug>Lightspeed_omni_s', opts)
keymap('n', '<leader>ff', '<cmd>Telescope git_files<cr>', opts)
keymap('n', '<leader>FF', '<cmd>Telescope find_files<cr>', opts)
keymap('n', '<leader>rg', '<cmd>Telescope live_grep<cr>', opts)
keymap('n', '<leader>gc', '<cmd>Telescope git_commits<cr>', opts)
