local function is_eslint_attached(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr or 0 })
  for _, client in ipairs(clients) do
    if client.name == "eslint" then
      return true
    end
  end
  return false
end

return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          bash = { "shfmt" },
          lua = { "stylua" },
          ruby = { lsp_format = "prefer" },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescriptreact = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          jsonc = { "prettierd" },
          graphql = { "prettierd" },
          css = { "prettierd" },

          -- -- Conform will run multiple formatters sequentially
          -- python = { "isort", "black" },
          -- -- You can customize some of the format options for the filetype (:help conform.format)
          -- rust = { "rustfmt", lsp_format = "fallback" },
          -- -- Conform will run the first available formatter
          -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },

        -- Setup autocmd to format on save
        format_after_save = function(bufnr)
          return {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "fallback",
          }, function(err, did_edit)
            if err then
              return
            end

            if not did_edit then
              return
            end

            if is_eslint_attached(bufnr) then
              vim.api.nvim_command("EslintFixAll")
            end
          end
        end,
      })
    end,
  },
}
