-- kanagawa lualine theme
local colors = require("kanagawa.colors").setup()
local kanagawa = {}
kanagawa.normal = {
  a = { bg = colors.crystalBlue, fg = colors.bg_dark },
  b = { bg = colors.winterBlue, fg = colors.crystalBlue },
  c = { bg = colors.bg_light0, fg = colors.fg },
}
kanagawa.insert = {
  a = { bg = colors.autumnGreen, fg = colors.bg_dark },
  b = { bg = colors.bg, fg = colors.autumnGreen },
}
kanagawa.command = {
  a = { bg = colors.boatYellow2, fg = colors.bg_dark },
  b = { bg = colors.bg, fg = colors.boatYellow2 },
}
kanagawa.visual = {
  a = { bg = colors.oniViolet, fg = colors.bg_dark },
  b = { bg = colors.bg, fg = colors.oniViolet },
}
kanagawa.replace = {
  a = { bg = colors.autumnRed, fg = colors.bg_dark },
  b = { bg = colors.bg, fg = colors.autumnRed },
}
kanagawa.inactive = {
  a = { bg = colors.bg_status, fg = colors.crystalBlue },
  b = { bg = colors.bg_status, fg = colors.fujiGray, gui = "bold" },
  c = { bg = colors.bg_status, fg = colors.fujiGray },
}
if vim.g.kanagawa_lualine_bold then
  for _, mode in pairs(kanagawa) do
    mode.a.gui = "bold"
  end
end

-- set lualine theme based on current colorscheme
local lualineTheme = 'auto'
local currentColorscheme = vim.cmd('colorscheme')

if currentColorscheme == 'gruvbox-material' then
  lualineTheme = 'gruvbox-material'
elseif currentColorscheme == 'kanagawa' then
  lualineTheme = 'kanagawa'
end


require 'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = lualineTheme,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'NvimTree' },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
