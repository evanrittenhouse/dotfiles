local M = {
  "folke/trouble.nvim",
  keys = {
    { "<Leader>td", ":TroubleToggle document_diagnostics<CR>" },
    { "<Leader>tw", ":TroubleToggle workspace_diagnostics<CR>" },
    { "<Leader>tc", ":TroubleClose<CR>" }
  }
}

return M
