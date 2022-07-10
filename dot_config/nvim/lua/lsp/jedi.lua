local lspconfig = require'lspconfig'
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end


local M = {}

M.setup = function(on_attach, capabilities)
    lspconfig['jedi_language_server'].setup{
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
        end
    }
end

return M
