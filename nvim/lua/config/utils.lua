local M = {}

M.requireConfigDirectory = function(directory)
  local pattern = vim.fn.stdpath('config') .. '/lua/config/' .. directory .. '/*.lua'
  local paths = vim.split(vim.fn.glob(pattern), '\n')

  for _, path in ipairs(paths) do
    dofile(path)
  end
end

return M
