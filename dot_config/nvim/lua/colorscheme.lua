-- require('kanagawa').setup({
--   transparent = true,
--   colors = {
--     theme = {
--       all = {
--         ui = {
--           bg_gutter = "none"
--         }
--       }
--     }
--   }
-- })

vim.api.nvim_set_var('gruvbox_material_transparent_background', 1)
vim.api.nvim_set_var('gruvbox_material_background', 'hard')
vim.cmd('colorscheme gruvbox-material')
