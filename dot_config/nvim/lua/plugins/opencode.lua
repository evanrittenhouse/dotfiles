local M = {
  "sudo-tee/opencode.nvim",
  config = function(_, opts)
    require("opencode").setup(opts)
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'opencode_output' },
      },
      ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
    },
    'saghen/blink.cmp',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    default_mode = "plan",
    ui = {
      position = "left",
      input = {
        text = {
          wrap = true
        }
      }
    }
  },
  event = "VeryLazy"
}

return M
