local module = {}

local function file_exists(name)
  local f = io.open(name,"r")

  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local proximity_sort_path = os.getenv('HOME') .. '/.nix-profile/bin/proximity-sort'
local proximity_sort_exists = file_exists(proximity_sort_path)

module.fzfFiles = function()
  local rg_command = "rg --files --hidden --glob '!{node_modules/*,.git/*}'"
  local base = vim.api.nvim_eval("fnamemodify(expand('%'), ':h:.:S')")
  local command = nil

  if base == '.' or not proximity_sort_exists then
    command = rg_command
  else
    local file = vim.api.nvim_eval("expand('%')")
    command = rg_command .. " | " .. proximity_sort_path .. " " .. file
  end

  require('fzf-lua').files({
    raw_cmd = command,
  })
end

return module
