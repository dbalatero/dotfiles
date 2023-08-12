-- The AWS VPN Client is terrible and steals focus all the time.

-- Set up an event tap that we can use to prevent space/return presses.
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

-- Set up a watcher to detect when the AWS VPN Client.app becomes the active
-- application.
vpnWatcher = hs.application.watcher.new(function(applicationName, eventType)
  -- Only handle application events for the VPN client.
  if applicationName ~= 'AWS VPN Client' then
    return
  end

  if eventType == hs.application.watcher.activated then
    -- When AWS VPN Client is the active application, prevent key presses
    print('Preventing accidental disconnects...')
    keyPrevention:start()
  elseif eventType == hs.application.watcher.deactivated then
    -- When we focus away from the VPN client, allow key presses
    print('...done preventing')
    keyPrevention:stop()
  end
end)

vpnWatcher:start()
