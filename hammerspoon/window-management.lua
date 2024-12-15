hs.window.animationDuration = 0

-- No margins between windows.
hs.grid.setMargins("0, 0")

local function setGridForScreens()
  -- Set screen grid depending on resolution
  for _, screen in pairs(hs.screen.allScreens()) do
    if screen:frame().w / screen:frame().h > 2 then
      -- 10 * 4 for ultra wide screen
      hs.grid.setGrid("10 * 4", screen)
    else
      if screen:frame().w < screen:frame().h then
        -- 4 * 8 for vertically aligned screen
        hs.grid.setGrid("4 * 8", screen)
      else
        -- 8 * 4 for normal screen
        hs.grid.setGrid("8 * 4", screen)
      end
    end
  end
end

-- Call meta once on config load.
setGridForScreens()

-- Set screen watcher, in case you connect a new monitor, or unplug a monitor
screenWatcher = hs.screen.watcher.new(function()
  setGridForScreens()
end)

screenWatcher:start()

-- Create a handy struct to hold the current window/screen and their grids.
local function windowMeta()
  local self = {}

  self.window = hs.window.focusedWindow()
  self.screen = self.window:screen()
  self.windowGrid = hs.grid.get(self.window)
  self.screenGrid = hs.grid.getGrid(self.screen)

  return self
end

--------------------------------------
-- Configure module functions
--------------------------------------

local module = {}

-- Maximizes a window to fit the entire grid.
module.maximizeWindow = function()
  local meta = windowMeta()
  hs.grid.maximizeWindow(meta.window)
end

-- Centers a window in the middle of the screen.
module.centerOnScreen = function()
  local meta = windowMeta()
  meta.window:centerOnScreen(meta.screen)
end

-- Throws a window 1 screen to the left
module.throwLeft = function()
  local meta = windowMeta()
  meta.window:moveOneScreenWest()
end

-- Throws a window 1 screen to the right
module.throwRight = function()
  local meta = windowMeta()
  meta.window:moveOneScreenEast()
end

-- 1. Moves a window all the way left
-- 2. Resizes it to take up the left half of the screen (grid)
module.leftHalf = function()
  local meta = windowMeta()
  local cell = hs.geometry(0, 0, 0.5 * meta.screenGrid.w, meta.screenGrid.h)

  hs.grid.set(meta.window, cell, meta.screen)
end

-- 1. Moves a window all the way right
-- 2. Resizes it to take up the right half of the screen (grid)
module.rightHalf = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    0.5 * meta.screenGrid.w,
    0,
    0.5 * meta.screenGrid.w,
    meta.screenGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

-- 1. Moves a window all the way to the top
-- 2. Resizes it to take up the top half of the screen (grid)
module.topHalf = function()
  local meta = windowMeta()
  local cell = hs.geometry(0, 0, meta.screenGrid.w, 0.5 * meta.screenGrid.h)

  hs.grid.set(meta.window, cell, meta.screen)
end

-- 1. Moves a window all the way to the bottom
-- 2. Resizes it to take up the bottom half of the screen (grid)
module.bottomHalf = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    0,
    0.5 * meta.screenGrid.h,
    meta.screenGrid.w,
    0.5 * meta.screenGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

-- Shrinks a window's size horizontally to the left.
module.shrinkLeft = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x,
    meta.windowGrid.y,
    meta.windowGrid.w - 1,
    meta.windowGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

-- Grows a window's size horizontally to the right.
module.growRight = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x,
    meta.windowGrid.y,
    meta.windowGrid.w + 1,
    meta.windowGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

-- Shrinks a window's size vertically up.
module.shrinkUp = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x,
    meta.windowGrid.y,
    meta.windowGrid.w,
    meta.windowGrid.h - 1
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

-- Grows a window's size vertically down.
module.growDown = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x,
    meta.windowGrid.y,
    meta.windowGrid.w,
    meta.windowGrid.h + 1
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

module.nudgeLeft = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x - 1,
    meta.windowGrid.y,
    meta.windowGrid.w,
    meta.windowGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

module.nudgeRight = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x + 1,
    meta.windowGrid.y,
    meta.windowGrid.w,
    meta.windowGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

module.nudgeUp = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x,
    meta.windowGrid.y - 1,
    meta.windowGrid.w,
    meta.windowGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

module.nudgeDown = function()
  local meta = windowMeta()
  local cell = hs.geometry(
    meta.windowGrid.x,
    meta.windowGrid.y + 1,
    meta.windowGrid.w,
    meta.windowGrid.h
  )

  hs.grid.set(meta.window, cell, meta.screen)
end

return module
