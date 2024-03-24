local M = {
  "nvim-telescope/telescope.nvim",
  event = "BufReadPre",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "burntsushi/ripgrep",
    "kyazdani42/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>" },
    { "<leader>FF", "<cmd>Telescope git_files<cr>" },
    { "<leader>rg", "<cmd>Telescope live_grep<cr>" },
    { "<leader>fo", "<cmd>Telescope oldfiles cwd_only=True<cr>" },
    { "<leader>tr", "<cmd>Telescope resume<cr>" },
    { "<leader>ch", "<cmd>Telescope command_history<cr>" }
  },
}

return M
