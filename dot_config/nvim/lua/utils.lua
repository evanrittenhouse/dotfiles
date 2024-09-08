local utils = {}

utils.keymap = vim.api.nvim_set_keymap
utils.keymap_opts = { noremap = true, silent = true }

utils.set_vim_option = function(option, arg)
  vim.opt[option] = arg
end

utils.string_ends_with = function(str, suffix)
    local suffix_len = string.len(suffix)
    return suffix_len > 0 and string.len(str) > 0 and string.sub(str, -suffix_len) == suffix
end

return utils
