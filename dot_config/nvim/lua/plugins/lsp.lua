local string_ends_with = require "utils".string_ends_with
local diagnostic = vim.diagnostic

-- Configuration for LSP diagnostics
diagnostic.config({
  virtual_text = {
    severity = diagnostic.severity.ERROR,
  },
  signs = {
    text = {
      [diagnostic.severity.ERROR] = 'E',
      [diagnostic.severity.WARN] = 'W',
      [diagnostic.severity.INFO] = '?',
      [diagnostic.severity.HINT] = ''
    }
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
  }
})

local setup_lsp_keybinds = function(bufnr)
  local function buf_set_keymap(key, cmd)
    vim.api.nvim_buf_set_keymap(bufnr, "n", key, cmd, { noremap = true, silent = true })
  end

  buf_set_keymap("gd", "<cmd>lua require('trouble').toggle('lsp_definitions')<CR>")
  buf_set_keymap("gr", "<cmd>lua require('trouble').toggle('lsp_references')<CR>")
  buf_set_keymap("gm", "<cmd>lua require('trouble').toggle('lsp_implementations')<CR>")
  buf_set_keymap("gs", "<cmd>lua require('trouble').toggle('lsp_document_symbols')<CR>")
  buf_set_keymap("<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  buf_set_keymap("gT", "<cmd>lua require('trouble').toggle('lsp_type_definitions')<CR>")
  buf_set_keymap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_set_keymap("[a", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  buf_set_keymap("]a", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  buf_set_keymap("ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  buf_set_keymap("<C-x><C-x>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  buf_set_keymap("gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    setup_lsp_keybinds(args.buf)

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ async = false, id = args.data.client_id })
      end
    })
  end
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local base_lsp = { capabilities = capabilities }

local M = {
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local servers = {
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "gopls",
        "zls"
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
          on_attach = function(client, _)
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
