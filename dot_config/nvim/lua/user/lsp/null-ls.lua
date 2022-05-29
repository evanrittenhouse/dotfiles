local null_ls = require("null-ls")

local M = {}
M.setup = function(on_attach)
    null_ls.setup({
        debug = true,
        sources = {
            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.black.with({
                extra_args = { "--fast" }
            }),
            null_ls.builtins.formatting.isort.with({
                extra_args = { "black" }
            }),
            null_ls.builtins.formatting.dart_format,
        },
        on_attach = on_attach,
    })
end

return M
