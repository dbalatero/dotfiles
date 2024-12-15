local ContextualModal = {}

function ContextualModal:new()
  local modal = {
    context = nil,
    eventBuffer = {},
  }

  setmetatable(modal, self)
  self.__index = self

  modal.tap = hs.eventtap.new(
    { hs.eventtap.event.types.keyDown },
    function(event)
      handler:queueEvent(event)
      return false
    end
  )

  return modal
end

function ContextualModal:setContext(name)
  self.context = name

  return self
end

function ContextualModal:queueEvent(event)
  table.insert(self.eventBuffer, event)

  return self
end

function ContextualModal:enter(contextName)
  self:setContext(contextName)

  if not self.context then
    self.tap:start()
  end
end

function ContextualModal:exit()
  self.tap:stop()
  self.eventBuffer = {}
  self.context = nil
end
