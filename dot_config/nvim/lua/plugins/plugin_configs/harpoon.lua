local keymap = require('utils').keymap
local opts = require('utils').keymap_opts

require('harpoon').setup {}
keymap('n', '<leader>am', ":lua require('harpoon.mark').add_file()<CR>", opts)
