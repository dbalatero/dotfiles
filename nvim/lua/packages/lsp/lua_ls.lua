-- TODO: integrate Hammerspoon: https://github.com/folke/lazydev.nvim/discussions/63
--   and: https://github.com/nathanmsmith/.config/blob/main/nvim/lua/lsp/lua_server.lua
local setup = require("packages.lsp.setup")

local base_settings = {
  Lua = {
    workspace = {
      checkThirdParty = false,
      library = {
        vim.env.VIMRUNTIME,
      },
    },
    telemetry = {
      enable = false,
    },
  },
}

local function create_hs_config()
  -- https://github.com/nathanmsmith/.config/blob/main/nvim/lua/lsp/lua_server.lua
  local hs_version = vim.fn.system("hs -c _VERSION"):gsub("[\n\r]", "")
  local hs_path =
    vim.split(vim.fn.system("hs -c package.path"):gsub("[\n\r]", ""), ";")

  local settings = vim.deepcopy(base_settings)

  settings.Lua.runtime = {
    version = hs_version,
    path = hs_path,
  }

  settings.Lua.diagnostics = {
    globals = { "hs" },
  }

  table.insert(
    settings.Lua.workspace.library,
    1,
    os.getenv("HOME") .. "/.hammerspoon/Spoons/EmmyLua.spoon/annotations"
  )

  return settings
end

require("lspconfig").lua_ls.setup({
  capabilities = setup.build_capabilities(),
  on_attach = function(client, bufnr)
    setup.on_attach(client, bufnr)

    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Hammerspoon support                                     │
    -- ╰─────────────────────────────────────────────────────────╯
    local path = client.workspace_folders[1].name

    if string.match(path, "hammerspoon") then
      -- TODO: This is not working because it thinks the path is
      -- ~/.config/dotfiles
      client.config.settings = create_hs_config()
      client.notify("workspace/didChangeConfiguration")
    end

    return true
  end,
  settings = base_settings,
})
