sleepWatcher = hs.caffeinate.watcher.new(function(state)
  if state == hs.caffeinate.watcher.systemDidWake then
    device = hs.audiodevice.defaultOutputDevice()

    if device then
      device:setMuted(true)
      hs.alert.show('Muted ' .. device:name())
    end
  end
end)

sleepWatcher:start()
