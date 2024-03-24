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
    "ggandor/leap.nvim",
    config = function()
      require("leap").create_default_mappings()
    end,
    event = BUF_READ,
  },
  {
    "tpope/vim-commentary",
    event = BUF_READ,
    keys = { mode = { "n", "v", "x" } },
    -- TODO: figure out how to lazily load vim-commentary, for some reason you need lazy = false and stuff
    lazy = false,
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    opts = {
      default_file_explorer = true
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
  },
  {
    "ThePrimeagen/harpoon",
    keys = { "<Leader>am", ":lua require ('harpoon.mark').add_file()<CR>" }
  },
  --   -- cmp plugins
  --   "hrsh7th/nvim-cmp",                -- The completion plugin
  --   "hrsh7th/cmp-buffer",              -- buffer completions
  --   "hrsh7th/cmp-path",                -- path completions
  --   "hrsh7th/cmp-cmdline",             -- cmdline completions
  --   "hrsh7th/cmp-nvim-lsp",            -- LSP completions
  --   "saadparwaiz1/cmp_luasnip",        -- snippet completions
  --   "L3MON4D3/LuaSnip",                --snippet engine
  --   "rafamadriz/friendly-snippets",    -- a bunch of snippets to use
  --
  --   "jose-elias-alvarez/null-ls.nvim", -- Formatter, etc. for LSP servers

}

return M
