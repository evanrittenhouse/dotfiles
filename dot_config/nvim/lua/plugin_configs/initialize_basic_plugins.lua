require('nvim-autopairs').setup {}
require('gitsigns').setup {}
require('nvim-surround').setup {}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "python", "javascript", "tsx", "typescript" },
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  index = {
    enable = false,
  }
}

local keymap = require('utils').keymap
local opts = require('utils').keymap_opts
require('lightspeed').setup {}
keymap('n', 's', '<Plug>Lightspeed_omni_s', opts)
