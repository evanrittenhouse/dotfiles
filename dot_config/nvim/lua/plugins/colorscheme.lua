local M = {
  {
    "rebelot/kanagawa.nvim",
    config = function(_, opts)
      require('kanagawa').setup(opts)

      -- vim.cmd('colorscheme kanagawa')
    end,
    lazy = false,
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
    overrides = function(colors)
      return {
        -- Set command line background
        MsgArea = { bg = colors.palette.sumiInk0 }
      }
    end,
    priority = 1000,
  },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.api.nvim_set_var('gruvbox_material_transparent_background', 1)
      vim.api.nvim_set_var('gruvbox_material_background', 'hard')

      vim.cmd('colorscheme gruvbox-material')
    end,
    lazy = false,
    priority = 1000
  },
}

return M
