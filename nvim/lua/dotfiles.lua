local M = {}

M.plugin_path = function()
  return vim.fn.stdpath("data") .. "/lazy"
end

return M
