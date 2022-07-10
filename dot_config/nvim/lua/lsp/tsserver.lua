local ts_utils = require("nvim-lsp-ts-utils")
local ts_utils_settings = {
    -- debug = true,
    import_all_scan_buffers = 100,
    update_imports_on_move = true,
    -- filter out dumb module warning
    filter_out_diagnostics_by_code = { 80001 },
    auto_inlay_hints = false,
}


ts_utils.init_options.preferences['includeCompletionsForModuleExports'] = true
ts_utils.init_options.preferences['includeCompletionsForImportStatements'] = true

local on_attach_override = function(on_attach, buf_map)
    on_attach = function (client, bufnr)
        on_attach(client, bufnr)
        ts_utils.setup(ts_utils_settings)
        ts_utils.setup_client(client)

        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gI", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
    end
end

return on_attach_override
