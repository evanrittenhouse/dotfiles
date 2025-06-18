local M = {
  "folke/trouble.nvim",
  opts = {
    focus = true,
    modes = {
      lsp_references = {
        auto_refresh = false
      },
      lsp_type_definitions = {
        auto_refresh = false
      },
      lsp_document_symbols = {
        win = {
          relative = "win",
          position = "left"
        },
      },
    }
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>tw",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>td",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>tL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>tQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}

return M
