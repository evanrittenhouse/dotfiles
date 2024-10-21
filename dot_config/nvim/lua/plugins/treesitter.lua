local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "python", "rust", "lua", "vimdoc", "cpp", "c" },
      highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false
      },
      index = {
        enable = false
      }
    })
  end
}

return M
