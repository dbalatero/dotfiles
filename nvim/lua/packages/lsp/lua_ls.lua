-- TODO: integrate Hammerspoon: https://github.com/folke/lazydev.nvim/discussions/63
--   and: https://github.com/nathanmsmith/.config/blob/main/nvim/lua/lsp/lua_server.lua
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local setup = require("packages.lsp.setup")

require("lspconfig").lua_ls.setup({
  capabilities = setup.build_capabilities(),
  on_attach = setup.on_attach,
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        },
      },
      telemetry = { enable = false },
    },
  },
})
