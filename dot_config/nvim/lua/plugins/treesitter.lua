local LANGUAGES = {
  "python", "rust", "lua", "go", "vimdoc", "cpp", "c", "zig",
  "markdown", "markdown_inline",
}

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

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'opencode_output',
      callback = function(args) vim.treesitter.start(args.buf) end,
    })
  end
}

return M
