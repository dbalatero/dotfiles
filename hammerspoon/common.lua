local HyperKey = hs.loadSpoon('HyperKey')

hyper = { 'ctrl', 'alt', 'cmd', 'shift' }
super = { 'ctrl', 'alt', 'cmd' }

hyperKey = HyperKey:new(hyper)
superKey = HyperKey:new(super)

function p(variable)
  print(hs.inspect.inspect(variable))
end

-- The default delay is too slow, making key repeating very slow
fast_delay = 1000
EVENTPROPERTY_EVENTSOURCEUSERDATA = 42
USERDATA_GENERATED = 55555
