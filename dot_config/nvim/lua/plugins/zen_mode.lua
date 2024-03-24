local toggle = function()
  require('zen-mode').toggle()
  vim.wo.wrap = false
end

local M = {
   "folke/zen-mode.nvim",
   opts = {
     window = {
       options = {
         number = true
       }
     }
   },
   keys = { 
     { "<Leader>zz", toggle } 
   }
}

return M
