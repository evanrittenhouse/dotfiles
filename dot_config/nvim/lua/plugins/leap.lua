local M = {
  "ggandor/leap.nvim",
  config = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')
    -- Don't map 'x' mode since it conflicts with nvim-surround
    vim.keymap.set({ 'n', 'o' }, 'S', '<Plug>(leap-backward)')
  end,
  event = { "BufReadPre", "BufReadPost" },
}

return M
