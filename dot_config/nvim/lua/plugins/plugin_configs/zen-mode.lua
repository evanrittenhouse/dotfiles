require("zen-mode").setup {
  window = {
    options = {
      number = true,
    }
  },
}

vim.keymap.set("n", "<Leader>zz", function()
  require('zen-mode').toggle()
  vim.wo.wrap = false
end)
