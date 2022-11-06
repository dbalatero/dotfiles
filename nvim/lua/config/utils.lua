local M = {}

M.requireConfigDirectory = function(directory)
  local files = vim.fn.readdir(
    vim.fn.stdpath('config') .. '/lua/' .. directory,
    [[v:val =~ '\.lua$']]
  )

  for _, file in ipairs(files) do
    local path = file
        :gsub('%.lua$', '')
        :gsub('/', '.')

    require('config.' .. path)
  end
end

return M
