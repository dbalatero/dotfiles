local MuteUi = require("zoom.mute-ui")
local statuses = require("zoom.status")

-----------------

muteStatus = MuteUi:new()

muteWatcher = hs.timer.new(2, function()
  if muteStatus.manuallyToggled then
    muteWatcher:setNextTrigger(2)
    return
  end

  local status = statuses.getStatus()

  if status == statuses.notMeeting then
    muteStatus:hide()

    muteWatcher:setNextTrigger(2)
  else
    muteStatus:show()
    muteStatus:setMuted(status == statuses.muted)

    -- Switch to checking every 100ms while in a meeting.
    muteWatcher:setNextTrigger(0.1)
  end
end)

zoomAppWatcher = hs.application.watcher.new(function(applicationName, eventType)
  if applicationName ~= "zoom.us" then
    return
  end

  if eventType == hs.application.watcher.launched then
    muteStatus:show()
  elseif eventType == hs.application.watcher.terminated then
    muteStatus:hide()
  end
end)

zoomAppWatcher:start()

if hs.application.find("zoom.us") then
  muteStatus:show()
  muteStatus:setMuted(statuses.getStatus() == statuses.muted)

  muteWatcher:start()
end

hyperKey:bind("z"):toFunction("Toggle mute status", function()
  muteStatus:toggle()
end)
