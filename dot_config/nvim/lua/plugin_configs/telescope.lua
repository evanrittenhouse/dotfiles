local telescope = require('telescope')

telescope.setup {}

telescope.load_extension('harpoon')

local keymap = require('utils').keymap
local opts = require('utils').keymap_opts
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
keymap('n', '<leader>FF', '<cmd>Telescope git_files<cr>', opts)
keymap('n', '<leader>rg', '<cmd>Telescope live_grep<cr>', opts)
keymap('n', '<leader>fo', '<cmd>Telescope oldfiles cwd_only=True<cr>', opts)
keymap('n', '<leader>fm', '<cmd>Telescope harpoon marks<cr>', opts)
