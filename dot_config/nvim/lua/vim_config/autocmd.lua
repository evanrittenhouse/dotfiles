local set_vim_option = require "utils".set_vim_option

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  group = misc_augroup,
  pattern = '*',
  command = 'silent! normal! g`"zv'
})

-- See https://www.reddit.com/r/neovim/comments/zmvk7j/wrap_lines_without_altering_the_file/
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Visually break lines in Markdown files without actually adding newlines',
  pattern = 'markdown',
  callback = function()
    -- `number` already set in options.lua
    set_vim_option('wrap', true)
    set_vim_option('textwidth', 0)
    set_vim_option('wrapmargin', 0)
    set_vim_option('linebreak', true)

    set_vim_option('tabstop', 8)
    set_vim_option('shiftwidth', 8)
    set_vim_option('breakindent', true)
  end
})
