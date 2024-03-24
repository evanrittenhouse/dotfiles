local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "burntsushi/ripgrep",
    "kyazdani42/nvim-web-devicons",
  },
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)
    telescope.load_extension("live_grep_args")
  end,
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>" },
    { "<leader>FF", "<cmd>Telescope git_files<cr>" },
    { "<leader>rg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>" },
    { "<leader>fo", "<cmd>Telescope oldfiles cwd_only=True<cr>" },
    { "<leader>tr", "<cmd>Telescope resume<cr>" },
    { "<leader>ch", "<cmd>Telescope command_history<cr>" }
  },
}

return M
