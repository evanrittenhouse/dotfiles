local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    "ggandor/leap.nvim",
    config = function() require("leap").add_default_mappings() end
  },
  {
    "stevearc/oil.nvim",
    config = function() require("oil").setup() end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- what to do here?
    build = ":TSUpdate",
  },
  {
    "freddiehaddad/feline.nvim",
    config = function() require('feline') end
  }, -- Status bar
  {
    "ThePrimeagen/harpoon",
    config = function() require('harpoon') end
  }, -- Marks v2
  {
    "nvim-telescope/telescope.nvim",
    config = function() require('telescope') end
  }, -- Telescope
  {
    "folke/trouble.nvim",
    config = function() require('trouble') end
  }, -- Diagnostics
  {
    "folke/zen-mode.nvim",
    config = function() require('zen-mode') end
  },                                 -- Center buffer
  "nvim-lua/popup.nvim",             -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/plenary.nvim",           -- Useful lua functions used by lots of plugins
  "lewis6991/gitsigns.nvim",         -- Git buffer signs
  "windwp/nvim-autopairs",           -- Pair characters ([], {}, etc.)
  "kylechui/nvim-surround",          -- Utilities for working with paired characters
  "lewis6991/impatient.nvim",        -- Faster startup times
  "leafOfTree/vim-matchtag",         -- Highlights matching character
  "tpope/vim-commentary",            -- Detect the symbol for comments in a file
  "kyazdani42/nvim-web-devicons",    -- Icons
  "tpope/vim-sleuth",                -- Detect indentation
  "tpope/vim-fugitive",              -- Vim Fugitive
  -- cmp plugins
  "hrsh7th/nvim-cmp",                -- The completion plugin
  "hrsh7th/cmp-buffer",              -- buffer completions
  "hrsh7th/cmp-path",                -- path completions
  "hrsh7th/cmp-cmdline",             -- cmdline completions
  "hrsh7th/cmp-nvim-lsp",            -- LSP completions
  "saadparwaiz1/cmp_luasnip",        -- snippet completions
  -- snippets
  "L3MON4D3/LuaSnip",                --snippet engine
  "rafamadriz/friendly-snippets",    -- a bunch of snippets to use
  -- LSP
  "neovim/nvim-lspconfig",           -- LSP config
  -- Formatting
  "jose-elias-alvarez/null-ls.nvim", -- Formatter, etc. for LSP servers

  -- "akinsho/flutter-tools.nvim",      -- Tools for flutter development

  -- Colorschemes
  --  'savq/melange-nvim'
  --  'rebelot/kanagawa.nvim'
  --  'folke/tokyonight.nvim'
  'sainnhe/gruvbox-material',
  --  'navarasu/onedark.nvim'

})
