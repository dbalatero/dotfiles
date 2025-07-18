local config = require("custom.config")

if not config.stripe.payServer then
  return
end

local function get_file_name()
  return vim.api.nvim_buf_get_name(0)
end

local rubocop_cmd = "scripts/bin/rubocop-server/rubocop"
local rubocop_args = {
  "--except",
  "PrisonGuard/AutogenLoaderPreamble",
  "-f",
  "json",
  "--stdin",
  get_file_name,
}

require("lint").linters.rubocop = {
  name = "Rubocop",
  cmd = rubocop_cmd,
  stdin = true, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
  args = rubocop_args, -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
  stream = "stdout", -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
  ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
  env = nil, -- custom environment table to use with the external process. Note that this replaces the *entire* environment, it is not additive.
  parser = function(output, bufnr)
    local rubocop_severities = {
      info = vim.diagnostic.severity.INFO,
      refactor = vim.diagnostic.severity.HINT,
      convention = vim.diagnostic.severity.HINT,
      warning = vim.diagnostic.severity.WARN,
      error = vim.diagnostic.severity.ERROR,
      fatal = vim.diagnostic.severity.ERROR,
    }

    local ok, rubocop_output = pcall(vim.json.decode, output)
    if not ok or rubocop_output == nil or vim.tbl_isempty(rubocop_output) then
      return {}
    end

    local offenses = rubocop_output.files[1].offenses
    local diagnostics = {}
    for _, offense in pairs(offenses) do
      local l = offense.location
      table.insert(diagnostics, {
        lnum = l.start_line - 1,
        col = l.start_column - 1,
        end_lnum = l.last_line - 1,
        end_col = l.last_column - 1,
        message = offense.message,
        severity = rubocop_severities[offense.severity],
        code = offense.cop_name,
        source = "Rubocop",
      })
    end
    return diagnostics
  end,
}
