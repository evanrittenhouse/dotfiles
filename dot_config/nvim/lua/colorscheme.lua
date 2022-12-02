-- require('kanagawa').setup({
--   transparent = true,
-- })
-- vim.api.nvim_set_var('gruvbox_material_transparent_background', 1)

require('onedark').setup {
  style = 'darker',
  transparent = true,
  lualine = {
    transparent = true
  }
}

vim.cmd('colorscheme onedark')
