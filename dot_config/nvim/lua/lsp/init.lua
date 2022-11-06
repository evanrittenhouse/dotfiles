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

local opts = require('utils').keymap_opts

local base_on_attach = function(client, bufnr)
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
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end


local null_ls = require('null-ls')
null_ls.setup {
    sources = {
        null_ls.builtins.formatting.black.with({
            extra_args = { "--fast" }
        }),
        null_ls.builtins.formatting.isort.with({
            extra_args = { "black" }
        }),
        null_ls.builtins.formatting.prettierd
    },
    on_attach = base_on_attach,
    should_attach = function(bufnr)
        return not vim.api.nvim_buf_get_name(bufnr):match('sequelize')
    end
}

-- LANGUAGE SERVER-SPECIFIC SETUP --
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lspconfig = require('lspconfig')
lspconfig['pyright'].setup {
    on_attach = base_on_attach,
    capabilities = capabilities,
    flags = {}
}

lspconfig['sumneko_lua'].setup {
    on_attach = base_on_attach,
    flags = {},
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
}

lspconfig['tsserver'].setup {
    on_attach = function(client, bufnr)
        base_on_attach(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    flags = {},
}

lspconfig['clangd'].setup {
    on_attach = base_on_attach,
    capabilities = capabilities,
    flags = {}
}


require('flutter-tools').setup {
    lsp = {
        on_attach = base_on_attach,
        capabilities = capabilities,
        settings = {
            dart = {
                lineLength = 132,
            }
        }
    }
}
