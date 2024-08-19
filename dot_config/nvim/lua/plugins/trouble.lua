local M = {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
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
      "<leader>ts",
      "<cmd>Trouble symbols toggle focus=false win.postition=left<cr>",
      desc = "Symbols (Trouble)",
    },
    -- disabled for now - telescope seems better (see lsp.lua)
    -- {
    --   "<leader>tl",
    --   "<cmd>Trouble lsp toggle focus=false win.position=left<cr>",
    --   desc = "LSP Definitions / references / ... (Trouble)",
    -- },
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
