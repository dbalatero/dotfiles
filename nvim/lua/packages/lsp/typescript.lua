local config = require("custom.config")

local ts_config = {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end

    require("packages.lsp.setup").on_attach(client, bufnr)
  end,
  root_dir = require("lspconfig").util.root_pattern("tsconfig.json"),
  settings = {
    expose_as_code_action = "all",
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
    tsserver_max_memory = "auto",
    tsserver_locale = "en",
    -- tsserver_logs = "verbose",
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,

      -- Ensure we always import from absolute paths
      importModuleSpecifierPreference = "non-relative",
    },
  },
  handlers = {
    ["textDocument/publishDiagnostics"] = function(_, result, ctx, lspConfig)
      if result.diagnostics == nil then
        return
      end

      local format_ts_errors = require("format-ts-errors")
      for _, entry in ipairs(result.diagnostics) do
        local formatter = format_ts_errors[entry.code]
        if formatter then
          entry.message = formatter(entry.message)
        end
      end

      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, lspConfig)
    end,
  },
}

local initTypescriptLsp = function()
  require("typescript-tools").setup(ts_config)
end

if config.stripe.payServer then
  local pay_server = config.stripe.payServerRootPath
  local tsserver_path = pay_server
    .. "/frontend/js-scripts/node_modules/typescript/lib/tsserver.js"

  ts_config.settings.tsserver_path = tsserver_path

  if not vim.loop.fs_stat(tsserver_path) then
    vim.notify("Installing pay-server js-scripts...", vim.log.levels.INFO)

    vim.fn.jobstart({
      pay_server .. "/frontend/js-cli/bin/js-cli",
      "install",
    }, {
      cwd = pay_server .. "/frontend/js-scripts",
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("Installed pay-server js-scripts!", vim.log.levels.INFO)
          initTypescriptLsp()
        else
          vim.notify("Error installing js-scripts", vim.log.levels.ERROR)
          ts_config.settings.tsserver_path = nil
        end
      end,
    })
  else
    initTypescriptLsp()
  end
else
  initTypescriptLsp()
end
