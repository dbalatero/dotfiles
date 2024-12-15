local function rgba(r, g, b, a)
  a = a or 1.0

  return {
    red = r / 255,
    green = g / 255,
    blue = b / 255,
    alpha = a,
  }
end

local MuteUI = {}

function MuteUI:new()
  local status = {
    isMuted = nil, -- starts as nil, unset
    colors = {
      unmuted = rgba(153, 255, 162, 1.0),
      muted = rgba(255, 160, 153, 1.0),
    },
    indexes = {
      background = 1,
      icon = 2,
      muteText = 3,
      horizontalLine = 4,
      verticalLine = 5,
      toggleHotkeyText = 6,
      hideHotkeyText = 7,
    },
    manuallyToggled = false,
  }

  setmetatable(status, self)
  self.__index = self

  local width = 225

  status.canvas = hs.canvas.new({
    x = hs.screen.primaryScreen():frame().w - width - 15,
    y = 40,
    w = width,
    h = 136,
  })

  status.canvas:level("overlay")

  status.canvas:insertElement({
    type = "rectangle",
    action = "fill",
    roundedRectRadii = { xRadius = 10, yRadius = 10 },
    fillColor = rgba(0, 0, 0, 0.85),
    withShadow = true,
    shadow = {
      blurRadius = 5.0,
      color = { alpha = 1 / 3 },
      offset = { h = -2.0, w = 2.0 },
    },
  }, status.indexes.background)

  status.canvas:insertElement({
    type = "image",
    action = "fill",
    image = hs.image.imageFromPath(
      os.getenv("HOME") .. "/.hammerspoon/zoom/volume-off.png"
    ),
    frame = {
      x = (status.canvas:size().w / 2) - 32,
      y = 4,
      w = 64,
      h = 64,
    },
  }, status.indexes.icon)

  status.canvas:insertElement({
    type = "text",
    action = "fill",
    text = "Muted",
    textAlignment = "center",
    textColor = status.colors.muted,
    textFont = "Helvetica Bold",
    textSize = 14,
    frame = {
      x = (status.canvas:size().w / 2) - 32,
      y = 64,
      w = 64,
      h = 20,
    },
  }, status.indexes.muteText)

  status.canvas:insertElement({
    type = "rectangle",
    action = "fill",
    fillColor = rgba(255, 255, 255, 0.5),
    frame = {
      x = 0,
      y = 94,
      w = "100%",
      h = 1,
    },
  }, status.indexes.horizontalLine)

  status.canvas:insertElement({
    type = "rectangle",
    action = "fill",
    fillColor = rgba(255, 255, 255, 0.5),
    frame = {
      x = status.canvas:size().w / 2,
      y = 95,
      w = 1,
      h = status.canvas:size().h - 95,
    },
  }, status.indexes.verticalLine)

  status.canvas:insertElement({
    type = "text",
    action = "fill",
    text = "Toggle\n⌘⇧⌥⌃ M",
    textAlignment = "center",
    textColor = rgba(255, 255, 255, 0.9),
    textFont = "Helvetica Bold",
    textSize = 12,
    frame = {
      x = 0,
      y = 100,
      w = status.canvas:size().w / 2,
      h = status.canvas:size().h - 100,
    },
  }, status.indexes.toggleHotkeyText)

  status.canvas:insertElement({
    type = "text",
    action = "fill",
    text = "Show/Hide\n⌘⇧⌥⌃ Z",
    textAlignment = "center",
    textColor = rgba(255, 255, 255, 0.9),
    textFont = "Helvetica Bold",
    textSize = 12,
    frame = {
      x = status.canvas:size().w / 2,
      y = 100,
      w = status.canvas:size().w / 2,
      h = status.canvas:size().h - 100,
    },
  }, status.indexes.hideHotkeyText)

  -- When the monitor changes (switch from laptop to external monitor, etc) we
  -- should make sure we reposition the UI element to sit in the corner
  -- correctly.
  status.screenWatcher = hs.screen.watcher.new(function()
    status:moveToCorner()
  end)

  status.screenWatcher:start()

  return status
end

function MuteUI:moveToCorner()
  local screenWidth = hs.screen.primaryScreen():frame().w
  local canvasWidth = self.canvas:frame().w

  self.canvas:topLeft({
    x = screenWidth - canvasWidth - 15,
    y = 40,
  })
end

function MuteUI:setMuted(muted)
  if isMuted == true and muted then
    return
  end
  if isMuted == false and not muted then
    return
  end

  if muted then
    self.canvas:elementAttribute(
      self.indexes.icon,
      "image",
      hs.image.imageFromPath(
        os.getenv("HOME") .. "/.hammerspoon/zoom/volume-off.png"
      )
    )

    self.canvas:elementAttribute(self.indexes.muteText, "text", "Muted")

    self.canvas:elementAttribute(
      self.indexes.muteText,
      "textColor",
      self.colors.muted
    )
  else
    self.canvas:elementAttribute(
      self.indexes.icon,
      "image",
      hs.image.imageFromPath(
        os.getenv("HOME") .. "/.hammerspoon/zoom/volume-on.png"
      )
    )

    self.canvas:elementAttribute(self.indexes.muteText, "text", "Unmuted")

    self.canvas:elementAttribute(
      self.indexes.muteText,
      "textColor",
      self.colors.unmuted
    )
  end
end

function MuteUI:show()
  if self.canvas:isShowing() then
    return
  end

  self:moveToCorner()

  -- fade in 200ms
  self.canvas:show(0.2)

  self.manuallyToggled = false
end

function MuteUI:hide()
  if not self.canvas:isShowing() then
    return
  end

  -- fade out 200ms
  self.canvas:hide(0.2)

  self.manuallyToggled = false
end

function MuteUI:toggle()
  if self.canvas:isShowing() then
    self:hide()
    self.manuallyToggled = true
  else
    self:show()
  end
end

return MuteUI
