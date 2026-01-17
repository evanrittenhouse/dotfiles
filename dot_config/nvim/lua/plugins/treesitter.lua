local LANGUAGES = {"python", "rust", "lua", "vimdoc", "cpp", "c", "zig"}

local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = LANGUAGES
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = LANGUAGES,
      callback = function() vim.treesitter.start() end,
    })
  end
}

return M
