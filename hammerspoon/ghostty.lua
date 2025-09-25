local function debounce(func, wait)
  local timer = nil
  return function(...)
    local args = { ... }

    if timer then
      timer:stop()
    end

    timer = hs.timer.doAfter(wait, function()
      func(table.unpack(args))
      timer = nil
    end)
  end
end

local forceGhosttyFullscreen = debounce(function()
  -- Find the Ghostty application
  local ghostty = hs.application.find("Ghostty")

  if ghostty then
    hs.eventtap.keyStroke({ "cmd" }, "return", 0, ghostty)
  end
end, 0.3)

screenWatcher = hs.screen.watcher.new(forceGhosttyFullscreen)

-- Start the watcher
screenWatcher:start()
