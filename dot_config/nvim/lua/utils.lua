local utils = {}

utils.keymap = vim.api.nvim_set_keymap
utils.keymap_opts = { noremap = true, silent = true }

utils.set_vim_option = function(option, arg)
  vim.opt[option] = arg
end

return utils
