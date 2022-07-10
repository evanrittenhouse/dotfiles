local M = {}
M.setup = function(on_attach, capabilities)
    local lspconfig = require("lspconfig")

    lspconfig["rust_analyzer"].setup({
        on_attach=on_attach,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "self",
                },
                cargo = {
                    loadOutDirsFromCheck = true
                },
                procMacro = {
                    enable = true
                },
            }
        }
    })
end

return M

