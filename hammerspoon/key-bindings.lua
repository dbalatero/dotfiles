-- reload Hammerspoon
hyperKey:bind('h'):toFunction('Reload Hammerspoon', function()
  hs.application.launchOrFocus('Hammerspoon')
  hs.reload()
end)
