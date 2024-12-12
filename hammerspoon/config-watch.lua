-- -----------------------------------------------------------------------
--                            ** For Debug **                           --
-- -----------------------------------------------------------------------

local hammerspoonDir = os.getenv('HOME') .. '/.hammerspoon/'

configWatcher = hs.pathwatcher.new(hammerspoonDir, function(files)
  local doReload = false

  for _, file in pairs(files) do
    -- If we saved a .lua file, we want to reload.
    if file:sub(-4) == '.lua' then
      doReload = true
    end
  end

  if doReload then
    hs.reload()
  end
end)

configWatcher:start()
