local telescope = require('telescope')

telescope.setup {}

telescope.load_extension('file_browser')

local keymap = require('utils').keymap
local opts = require('utils').keymap_opts
keymap('n', '<leader>ff', '<cmd>Telescope git_files<cr>', opts)
keymap('n', '<leader>FF', '<cmd>Telescope find_files<cr>', opts)
keymap('n', '<leader>rg', '<cmd>Telescope live_grep<cr>', opts)
keymap('n', '<leader>fb', '<cmd>Telescope file_browser<cr>', opts)
