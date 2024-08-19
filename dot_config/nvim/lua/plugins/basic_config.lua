local BUF_READ = { "BufReadPre", "BufReadPost" }
local M = {
  { "tpope/vim-sleuth" },
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    -- TODO: remove config = true
    config = true,
    event = { "BufReadPre", "BufReadPost", "BufNewFile" },
  },
  {
    "tpope/vim-commentary",
    event = BUF_READ,
    keys = { mode = { "n", "v", "x" } },
    -- TODO: figure out how to lazily load vim-commentary, for some reason you need lazy = false and stuff
    lazy = false,
  },
  {
    -- Can't lazy-load or `vim .` will use netrw
    "stevearc/oil.nvim",
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  {
    "ludovicchabant/vim-gutentags",
    ft = { "c", "lua", "cpp" }
  }

  -- {
  --   "ThePrimeagen/harpoon",
  --   keys = { "<Leader>am", ":lua require ('harpoon.mark').add_file()<CR>" }
  -- },
  --   "jose-elias-alvarez/null-ls.nvim", -- Formatter, etc. for LSP servers
}

return M
