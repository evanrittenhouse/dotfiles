local string_ends_with = require "utils".string_ends_with

-- Configuration for LSP diagnostics
vim.diagnostic.config({
  virtual_text = false, -- Turn off inline diagnostics
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = { focusable = false, style = "minimal", border = "rounded", source = "always", header = "", prefix = "" }
})

local telescope_cmd = function(arg)
  if arg ~= nil then
    local no_paren = not string_ends_with(arg, "()")
    local paren_opt = no_paren and "()" or ""

    return "<cmd>lua require ('telescope.builtin')." .. arg .. paren_opt .. "<CR>"
  end
end

-- Base callback called when attaching an LSP to a buffer
-- TODO: create autocmd instead of this
local base_on_attach = function(_, bufnr)
  -- Format on save
  vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")

  local function buf_set_keymap(key, cmd)
    vim.api.nvim_buf_set_keymap(bufnr, "n", key, cmd, { noremap = true, silent = true })
  end

  buf_set_keymap("gd", telescope_cmd("lsp_definitions"))
  buf_set_keymap("gr", telescope_cmd("lsp_references"))
  buf_set_keymap("gm", telescope_cmd("lsp_implementations"))
  buf_set_keymap("gs", telescope_cmd("lsp_document_symbols"))
  buf_set_keymap("<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  buf_set_keymap("gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  buf_set_keymap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_set_keymap("[a", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  buf_set_keymap("]a", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  buf_set_keymap("ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_set_keymap("<C-x><C-x>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  buf_set_keymap("gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local base_lsp = {
  on_attach = base_on_attach,
  capabilities = capabilities
}

local M = {
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local servers = {
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "tsserver",
        "gopls"
      }

      local lspconfig = require("lspconfig")
      for _, server in ipairs(servers) do
        local settings = opts.servers[server]
        local actual_settings = settings ~= nil and settings or base_lsp

        lspconfig[server].setup(actual_settings)
      end
    end,
    dependencies = {
      "hrsh7th/nvim-cmp"
    },
    event = "BufReadPre",
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        lua_ls = {
          flags = {},
          on_attach = base_on_attach,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                }
              }
            }
          }
        },
        tsserver = {
          on_attach = function(client, bufnr)
            base_on_attach(client, bufnr)
            client.server_capabilities.document_formatting = false
            client.server_capabilities.document_range_formatting = false
          end,
          flags = {}
        },
      },
    },
  },
}

return M

-- TODO: need none-ls for Python dev, but not going to do it now
-- {
--   "nvimtools/none-ls.nvim",
--   events = LSP_EVENTS,
--   cmd = LSP_CMDS,
--   opts = {
--     sources = {
--       -- none-ls only changes the plugin name
--       null_ls.builtins.formatting.black.with({
--         extra_args = { "--fast" }
--       }),
--       null_ls.builtins.formatting.isort.with({
--         extra_args = { "black" }
--       })
--     },
--     on_attach = base_on_attach,
--     should_attach = function(bufnr)
--         return (
--             not vim.api.nvim_buf_get_name(bufnr):match('sequelize') and
--             not vim.api.nvim_buf_get_name(bufnr):match('RustPython'))
--     end
--   }
-- }
