local lspconfig = require('lspconfig')

local M = {}

M.setup = function(on_attach, capabilities)
    lspconfig['pyright'].setup{}
end

return M
