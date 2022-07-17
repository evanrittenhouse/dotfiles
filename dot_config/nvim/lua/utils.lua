local utils = {}

utils.keymap = vim.api.nvim_set_keymap
utils.keymap_opts = { noremap = true, silent = true }

return utils
