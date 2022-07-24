require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "javascript", "tsx", "html", "typescript", "norg" },
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  index = {
    enable = false,
  }
}
