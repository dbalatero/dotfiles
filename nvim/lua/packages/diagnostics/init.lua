local config = require("custom.config")

return {
  "dbalatero/nvim-lint",
  -- Get stevearc's patch for fixing lint timeouts & lock ups
  branch = "custom-fork",
  config = function()
    require("packages.diagnostics.rubocop")

    local lint = require("lint")

    lint.linters_by_ft = {}

    if config.stripe.payServer then
      lint.linters.vale.args = vim.list_extend({
        "--config",
        config.stripe.payServerRootPath .. "/docs/vale/.vale.ini",
      }, lint.linters.vale.args)

      lint.linters_by_ft.markdown = { "vale" }
      lint.linters_by_ft.ruby = { "rubocop" }
    end

    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Autocmds for linting                                    │
    -- ╰─────────────────────────────────────────────────────────╯
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- local timer = assert(vim.loop.new_timer())
    -- local DEBOUNCE_MS = 300
    -- local aug = vim.api.nvim_create_augroup("Lint", { clear = true })
    --
    -- vim.api.nvim_create_autocmd(
    --   { "BufWritePost", "TextChanged", "InsertLeave" },
    --   {
    --     group = aug,
    --     callback = function()
    --       local bufnr = vim.api.nvim_get_current_buf()
    --       timer:stop()
    --       timer:start(
    --         DEBOUNCE_MS,
    --         0,
    --         vim.schedule_wrap(function()
    --           if vim.api.nvim_buf_is_valid(bufnr) then
    --             vim.api.nvim_buf_call(bufnr, function()
    --               lint.try_lint(nil, { ignore_errors = true })
    --             end)
    --           end
    --         end)
    --       )
    --     end,
    --   }
    -- )
  end,
}
