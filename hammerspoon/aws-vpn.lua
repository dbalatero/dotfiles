keyPrevention = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local keyPressed = hs.keycodes.map[event:getKeyCode()]

  if keyPressed == 'return' or keyPressed == 'space' then
    -- Prevent return/space from triggering the Disconnect button
    return true
  else
    -- Let all other keys through (including cmd+tab, etc)
    return false
  end
end)

vpnWatcher = hs.application.watcher.new(function(applicationName, eventType)
  if applicationName ~= 'AWS VPN Client' then
    return
  end

  if eventType == hs.application.watcher.activated then
    -- When AWS VPN Client is the active application, prevent key presses
    keyPrevention:start()
  elseif eventType == hs.application.watcher.deactivated then
    -- When we focus away from the VPN client, disable key prevention
    keyPrevention:stop()
  end
end)

vpnWatcher:start()
