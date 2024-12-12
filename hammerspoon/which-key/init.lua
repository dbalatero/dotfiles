local onModifierHold = require('which-key.on-modifier-hold')
local Overlay = require('which-key.overlay')
local bindings = require('which-key.bindings')

------------------------------------------

local WhichKey = {}

function WhichKey:new(modifiers)
  local instance = {}

  setmetatable(instance, self)
  self.__index = self

  instance.modifiers = modifiers
  instance.keyBindings = {}
  instance.overlay = Overlay:new(self.keyBindings)

  local overlayTimeoutMs = 250 -- wait 250ms before showing overlay

  local onHold = function()
    instance.overlay:show()
  end

  local onRelease = function()
    instance.overlay:hide()
  end

  instance.holdTap = onModifierHold(modifiers, overlayTimeoutMs, onHold, onRelease)

  return instance
end

-- :bind() either takes in a single key to bind,
-- or a pair of keys corresponding to the key you want to display on the
-- popup overlay (`displayedKey`) and the key you want to bind your function to
-- (`bindKey`)
function WhichKey:bind(displayedKey, bindKey)
  bindKey = bindKey or displayedKey

  -- We just return an object here with `toApplication` and
  -- `toFunction`, so we can chain our API like:
  --
  --   hyperKey:bind('t'):toApplication('/Applications/Utilities/Terminal.app')
  return {
    toApplication = function(_, applicationName)
      return self:_bind(displayedKey, bindKey, bindings.ApplicationBinding:new(applicationName))
    end,
    toFunction = function(_, name, fn)
      return self:_bind(displayedKey, bindKey, bindings.FunctionBinding:new(name, fn))
    end,
  }
end

function WhichKey:_bind(key, bindKey, binding)
  -- Save the key binding in our table, so the overlay knows to draw it
  -- on the screen
  table.insert(self.keyBindings, {
    key = key,
    bindKey = bindKey,
    binding = binding,
  })

  -- Bind the actual hotkey to the binding's `launch()` function, as defined
  -- in `bindings.lua`.
  hs.hotkey.bind(self.modifiers, bindKey, function()
    binding:launch()
  end)

  return self
end

return WhichKey
