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
  if not ghostty then
    return
  end

  -- Get the main window of Ghostty
  local ghosttyWindow = ghostty:mainWindow()
  if not ghosttyWindow then
    return
  end

  -- Get the window's current frame and the screen it's on
  local windowFrame = ghosttyWindow:frame()
  local screen = ghosttyWindow:screen()
  if not screen then
    return
  end

  local screenFrame = screen:frame()
  
  -- Check if window dimensions match screen dimensions
  -- Using a small tolerance (1-2 pixels) to account for potential rounding
  local tolerance = 2
  local widthMatches = math.abs(windowFrame.w - screenFrame.w) <= tolerance
  local heightMatches = math.abs(windowFrame.h - screenFrame.h) <= tolerance
  local xMatches = math.abs(windowFrame.x - screenFrame.x) <= tolerance
  local yMatches = math.abs(windowFrame.y - screenFrame.y) <= tolerance
  
  -- If already fullscreen, don't send the keystroke
  if widthMatches and heightMatches and xMatches and yMatches then
    return
  end

  -- Send fullscreen command
  hs.eventtap.keyStroke({ "cmd" }, "return", 0, ghostty)
end, 0.3)

screenWatcher = hs.screen.watcher.new(forceGhosttyFullscreen)

-- Start the watcher
screenWatcher:start()
