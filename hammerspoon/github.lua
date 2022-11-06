local function mergebotSubmit()
  hs.eventtap.keyStrokes('MERGEBOT_SUBMIT')
  hs.eventtap.keyStroke({ 'cmd' }, 'return')
end

hyperKey:bind('u'):toFunction('Mergebot submit', mergebotSubmit)
