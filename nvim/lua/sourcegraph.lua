-- ~/.config/nvim/lua/sourcegraph.lua
local M = {}

-- Browse function that handles both normal and visual mode
function M.browse(line1, line2)
  -- Get git root directory
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    vim.notify("Not inside a git repository", vim.log.levels.ERROR)
    return
  end

  -- Get current file path relative to repo root
  local current_file = vim.fn.expand("%:p")
  local relative_path = string.sub(current_file, string.len(git_root) + 2)

  -- Get current commit hash
  local commit_hash = vim.fn.systemlist("git rev-parse HEAD")[1]
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get git commit hash", vim.log.levels.ERROR)
    return
  end

  -- Get repo info
  local remote_url = vim.fn.systemlist("git config --get remote.origin.url")[1]
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get git remote URL", vim.log.levels.ERROR)
    return
  end

  -- Extract repo path (e.g., stripe-internal/pay-server)
  local repo_path = remote_url:match(".*[:/]([^/]*/[^/]*)%.git$")
  if not repo_path then
    vim.notify(
      "Could not parse repository path from git remote URL",
      vim.log.levels.ERROR
    )
    return
  end

  -- Create line parameter string
  local line_param = ""
  if line1 == line2 then
    line_param = "?L" .. line1
  else
    line_param = "?L" .. line1 .. "-" .. line2
  end

  -- Construct Sourcegraph URL
  local sourcegraph_url = "https://stripe.sourcegraphcloud.com/"
    .. repo_path
    .. "@"
    .. commit_hash
    .. "/-/blob/"
    .. relative_path
    .. line_param

  -- Copy to clipboard
  vim.fn.setreg("+", sourcegraph_url)

  vim.notify(
    "Copied Sourcegraph link to clipboard\n" .. sourcegraph_url,
    vim.log.levels.INFO
  )
end

vim.api.nvim_create_user_command("Sgbrowse", function(opts)
  -- Check if this is a manual line range, visual selection, or whole file
  local mode = vim.api.nvim_get_mode().mode
  local is_visual = mode:match("^[vV]") ~= nil
  local has_range = opts.range > 0

  if not has_range and not is_visual then
    -- No range specified and not in visual mode - use entire file
    local line_count = vim.api.nvim_buf_line_count(0)
    M.browse(1, line_count)
  else
    -- Has range or is visual selection - use specified range
    M.browse(opts.line1, opts.line2)
  end
end, { range = true })

vim.keymap.set("n", "<leader>ys", ":Sgbrowse<CR>", {
  desc = "Copy Sourcegraph link to current file",
  noremap = true,
  silent = true,
})

vim.keymap.set("v", "<leader>ys", ":<C-u>'<,'>Sgbrowse<CR>", {
  desc = "Copy Sourcegraph link to current selection",
  noremap = true,
  silent = true,
})

return M
