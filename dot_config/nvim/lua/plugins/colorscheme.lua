local M = {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        }
      },
      background = {
        dark = "wave",
        light = "lotus"
      }
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      vim.cmd('colorscheme kanagawa')
    end
  },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.api.nvim_set_var('gruvbox_material_transparent_background', 1)
      vim.api.nvim_set_var('gruvbox_material_background', 'hard')
    end
  },
  { 'savq/melange-nvim' },
}

return M
