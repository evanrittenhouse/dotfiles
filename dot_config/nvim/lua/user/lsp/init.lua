local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

vim.diagnostic.config({
    virtual_text = false, -- Turn off inline diagnostics
    signs = { active = signs },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = { focusable = false, style = "minimal", border = "rounded", source = "always", header = "", prefix = "" }
})

local opts = { silent = true, noremap = true }

local on_attach = function(client, bufnr)
    local function buf_set_keymap(key, cmd)
        vim.api.nvim_buf_set_keymap(bufnr, "n", key, cmd, opts)
    end

    buf_set_keymap("gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>")
    buf_set_keymap("gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>")
    buf_set_keymap("gs", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>")
    buf_set_keymap("<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    buf_set_keymap("gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    buf_set_keymap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    buf_set_keymap("[a", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
    buf_set_keymap("]a", "<cmd>lua vim.diagnostic.goto_next()<CR>")
    buf_set_keymap("ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    buf_set_keymap("<C-x><C-x>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    buf_set_keymap("gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
    buf_set_keymap("gO", ":TSLspOrganize<CR>")
    buf_set_keymap("gI", ":TSLspRenameFile<CR>")
    buf_set_keymap("go", ":TSLspImportAll<CR>")
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

require("user.lsp.null-ls").setup(on_attach)
-- require("user.lsp.null-ls")


local lsp_installer = require("nvim-lsp-installer")

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities
    }

    -- (optional) Customize the options passed to the server
    if server.name == "tsserver" then
        local ts_utils = require("nvim-lsp-ts-utils")
        local ts_utils_settings = {
            -- debug = true,
            import_all_scan_buffers = 100,
            update_imports_on_move = true,
            -- filter out dumb module warning
            filter_out_diagnostics_by_code = { 80001 },
            auto_inlay_hints = false,
        }

        opts.on_attach = function(client, _)
            ts_utils.setup(ts_utils_settings)
            ts_utils.setup_client(client)

            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
        end
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
