require('kanagawa').setup({
  transparent = true,
})
vim.api.nvim_set_var('gruvbox_material_transparent_background', 1)

vim.cmd('colorscheme kanagawa')
