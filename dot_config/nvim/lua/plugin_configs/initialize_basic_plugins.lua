require('nvim-autopairs').setup {}
require('gitsigns').setup {}
require('nvim-surround').setup {}
require('leap').add_default_mappings()

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
