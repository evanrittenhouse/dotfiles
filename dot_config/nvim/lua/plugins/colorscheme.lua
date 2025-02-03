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
      background = {
        dark = "wave",
        light = "lotus"
      }
    },
    overrides = function(colors)
      local theme = colors.theme
      return {
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },

        -- Save an hlgroup with dark background and dimmed foreground
        -- so that you can use it where your still want darker windows.
        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

        -- Popular plugins that open floats will link to NormalFloat by default;
        -- set their background accordingly if you wish to keep them dark and borderless
        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

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
  { 
    "savq/melange-nvim",
    config = function()
      -- vim.cmd('colorscheme melange')
    end
  }
}

return M
