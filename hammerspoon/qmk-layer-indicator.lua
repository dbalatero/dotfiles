local function rgba(r, g, b, a)
  a = a or 1.0

  return {
    red = r / 255,
    green = g / 255,
    blue = b / 255,
    alpha = a,
  }
end

-- see http://colorsafe.co for combos
local layers = {
  default = {
    name = "qwerty",
    background = rgba(187, 187, 187),
    foreground = rgba(46, 52, 59),
  },
  raise = {
    name = "raise",
    background = rgba(163, 209, 255),
    foreground = rgba(15, 72, 128),
  },
}

-------------------------

local LayerIndicator = {}

local defaultWidth = 75
local defaultHeight = 16
local elementIndexBox = 1
local elementIndexText = 2

function LayerIndicator:new(defaultLayer)
  local indicator = {
    layer = defaultLayer,
    appWatcher = nil,
    caffeineWatcher = nil,
  }

  setmetatable(indicator, self)
  self.__index = self

  indicator.canvas = hs.canvas.new({
    w = defaultWidth,
    h = defaultHeight,
    x = 0,
    y = 0,
  })

  indicator.canvas:insertElement({
    type = "rectangle",
    action = "fill",
    roundedRectRadii = { xRadius = 4, yRadius = 4 },
    fillColor = { red = 0, green = 0, blue = 0, alpha = 1.0 },
    frame = { x = "0%", y = "0%", h = "100%", w = "100%" },
  }, elementIndexBox)

  indicator.canvas:insertElement({
    type = "text",
    action = "fill",
    frame = {
      x = "10%",
      y = "0%",
      h = "100%",
      w = "95%",
    },
    text = "",
  }, elementIndexText)

  indicator:render()
  indicator:show()
  indicator:startWatchers()

  return indicator
end

function LayerIndicator:startWatchers()
  local delayRender = function()
    hs.timer.doAfter(10 / 1000, function()
      self:render()
    end)
  end

  -- fix alt tabbing from fullscreen games/etc not re-rendering correctly
  self.appWatcher = hs.application.watcher.new(
    function(applicationName, eventType)
      if eventType == hs.application.watcher.activated then
        delayRender()
      end
    end
  )

  self.appWatcher:start()

  -- fix render on sleep/wake/etc
  local caffeineEvents = {}
  caffeineEvents[hs.caffeinate.watcher.systemDidWake] = true
  caffeineEvents[hs.caffeinate.watcher.screensDidUnlock] = true
  caffeineEvents[hs.caffeinate.watcher.screensDidWake] = true

  self.caffeineWatcher = hs.caffeinate.watcher.new(function(eventType)
    if caffeineEvents[eventType] then
      delayRender()
    end
  end)

  self.caffeineWatcher:start()
end

function LayerIndicator:render()
  local canvas = self.canvas

  -- set the text
  canvas:elementAttribute(
    elementIndexText,
    "text",
    hs.styledtext.new(self.layer.name, {
      font = { name = "Helvetica Bold", size = 11 },
      color = self.layer.foreground,
      kerning = 0.5,
    })
  )

  -- box color
  canvas:elementAttribute(elementIndexBox, "fillColor", self.layer.background)

  -- position
  local frame = self:getFrame()
  local frameWidth = frame.w

  -- put the indicator in the middle of the screen
  local x = (frameWidth / 2) - (defaultWidth / 2)
  local y = 3 -- hardcode, you can change this

  canvas:topLeft({
    x = x,
    y = 3,
  })
end

function LayerIndicator:show()
  if self.layer.name == layers.default.name then
    self.canvas:hide()
  else
    self.canvas:show()

    -- show it above the Menu Bar
    self.canvas:level("overlay")
  end
end

function LayerIndicator:getFrame()
  return hs.screen.mainScreen():frame()
end

function LayerIndicator:setLayer(layer)
  self.layer = layer
  self:show()
  self:render()
end

--------------- bindings

local lowTom = hs.sound.getByFile(
  os.getenv("HOME") .. "/.hammerspoon/sounds/808-tom-low.wav"
)
local highTom = hs.sound.getByFile(
  os.getenv("HOME") .. "/.hammerspoon/sounds/808-tom-high.wav"
)

lowTom:volume(0.05)
highTom:volume(0.05)

local indicator = LayerIndicator:new(layers.default)

hs.hotkey.bind({}, "f17", function()
  indicator:setLayer(layers.raise)

  highTom:currentTime(0)
  highTom:play()
end)

hs.hotkey.bind({}, "f18", function()
  indicator:setLayer(layers.default)

  lowTom:currentTime(0)
  lowTom:play()
end)
