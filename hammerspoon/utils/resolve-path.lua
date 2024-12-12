local function file_exists(name)
  local f = io.open(name, 'r')

  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function resolvePath(locations)
  for _, path in ipairs(locations) do
    if file_exists(path) then
      return path
    end
  end

  return nil
end

return resolvePath
