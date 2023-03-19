local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lsp_format = require('lsp-format')
local lsp_signature = require('lsp_signature')

local M = {}

--  ╭──────────────────────────────────────────────────────────╮
--  │ shared capabilities                                      │
--  ╰──────────────────────────────────────────────────────────╯
M.default_capabilities = vim.lsp.protocol.make_client_capabilities()

-- Mix in the nvim-cmp capabilities:
M.default_capabilities = vim.tbl_extend('keep', M.default_capabilities, cmp_nvim_lsp.default_capabilities())

--  ╭──────────────────────────────────────────────────────────╮
--  │ shared on_attach handler                                 │
--  ╰──────────────────────────────────────────────────────────╯

M.on_attach = function(client, bufnr)
  lsp_format.on_attach(client, bufnr)

  -- Floating window signature
  lsp_signature.on_attach({
    debug = false,
    handler_opts = {
      border = 'single',
    },
  })
end

return M
