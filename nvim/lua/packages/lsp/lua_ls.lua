-- TODO: integrate Hammerspoon: https://github.com/folke/lazydev.nvim/discussions/63
--   and: https://github.com/nathanmsmith/.config/blob/main/nvim/lua/lsp/lua_server.lua
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
      telemetry = {
        enable = false,
      },
    },
  },
})
