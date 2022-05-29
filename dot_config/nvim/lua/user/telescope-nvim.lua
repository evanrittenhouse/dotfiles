local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', '<leader>ff', '<cmd>Telescope git_files<cr>', opts)
keymap('n', '<leader>FF', '<cmd>Telescope find_files<cr>', opts)
keymap('n', '<leader>rg', '<cmd>Telescope live_grep<cr>', opts)
keymap('n', '<leader>gc', '<cmd>Telescope git_commits<cr>', opts)
