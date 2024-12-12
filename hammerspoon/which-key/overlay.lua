local buildCanvas = require('which-key.build-canvas')

local Overlay = {}

-- Takes in a table of key bindings so we can pass them along to
-- buildCanvas() later.
function Overlay:new(bindings)
  local overlay = {
    bindings = bindings or {},
    canvas = nil,
  }

  setmetatable(overlay, self)
  self.__index = self

  return overlay
end

function Overlay:show()
  self.canvas = buildCanvas(self.bindings)
  self.canvas:show(0.15) -- fade in for 150ms
end

function Overlay:hide()
  self.canvas:delete(0.15) -- fade out for 150ms
  self.canvas = nil
end

return Overlay
