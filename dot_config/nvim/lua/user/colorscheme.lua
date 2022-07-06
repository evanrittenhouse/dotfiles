local colorscheme = 'gruvbox-material'
vim.api.nvim_set_var('gruvbox_material_background', 'hard')
-- local colorscheme = 'kanagawa'

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found")
  return
end
