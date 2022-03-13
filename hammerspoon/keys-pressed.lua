-- keyFrequencies = {}

-- keysWatcher = hs.eventtap.new(
--   { hs.eventtap.event.types.keyDown },
--   function(event)
--     local keyPressed = hs.keycodes.map[event:getKeyCode()]
--     keyFrequencies[keyPressed] = (keyFrequencies[keyPressed] or 0) + 1

--     return false
--   end
-- )

-- -- dump stats to hammerspoon console
-- hs.hotkey.bind({'cmd','shift','alt'}, '9', function()
--   for key, value in pairs(keyFrequencies) do
--     print("Key: " .. key .. ", times pressed: " .. tostring(value))
--   end
-- end)

-- keysWatcher:start()
