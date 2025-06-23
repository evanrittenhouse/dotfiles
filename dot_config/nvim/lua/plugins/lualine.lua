local SEPARATORS = { left = "", right = ""}
local BACKGROUND_COLOR = "#3c3836"

local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lsp_clients = function()
      local clients = vim.lsp.get_clients()
      if next(clients) == nil then
        return ""
      end

      local c = {}
      for _, client in pairs(clients) do
        table.insert(c, client.name)
      end

      return table.concat(c, "|")
    end

    -- Changing the background color is pretty jarring, so hardcode it
    local gruvbox_material = require("lualine.themes.gruvbox-material")
    gruvbox_material.normal.a.fg = BACKGROUND_COLOR
    gruvbox_material.insert.a.fg = BACKGROUND_COLOR
    gruvbox_material.replace.a.fg = BACKGROUND_COLOR
    gruvbox_material.command.a.fg = BACKGROUND_COLOR
    gruvbox_material.inactive.a.fg = BACKGROUND_COLOR

    require("lualine").setup({
      options = {
        component_separators = "",
        section_separators = SEPARATORS,
        theme = 'gruvbox-material',
      },
      sections = {
        lualine_a = {
          {
            "mode",
            separator = SEPARATORS,
          },
        },
        lualine_b = {
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 }
          },
          {
            "filename",
            separator = { right = SEPARATORS.right }
          }
        },
        lualine_c = {
          {
            "branch",
            icon = ""
          },
          {
            "diff",
            symbols = { added = "+", removed = "-", modified = "~" }
          }
        },
        lualine_x = {
          { 
            "diagnostics",
            sources = { "nvim_workspace_diagnostic" }
          }
        },
        lualine_y = {
          {
            lsp_clients,
            icon = "",
            separator = { left = SEPARATORS.left }
          }
        },
        lualine_z = {
          { "location", separator = SEPARATORS, icon = "" },
        },
      },
    })
  end
}

return M
