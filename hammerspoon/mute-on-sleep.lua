local function isDeviceAllowlisted(device)
  -- Which devices should we skip muting for?
  local allowedDevices = {
    "Schiit",
    "WH-1000",
  }

  for _, allowedPattern in ipairs(allowedDevices) do
    if device:name():match(allowedPattern) then
      return true
    end
  end

  return false
end

sleepWatcher = hs.caffeinate.watcher.new(function(state)
  if state == hs.caffeinate.watcher.systemDidWake then
    device = hs.audiodevice.defaultOutputDevice()

    if not device then
      return
    end

    if isDeviceAllowlisted(device) then
      print("Skipping mute for allowlisted audio device: " .. device:name())
    else
      device:setMuted(true)
      print("Muted audio device: " .. device:name())
      hs.alert.show("Muted " .. device:name())
    end
  end
end)

sleepWatcher:start()
