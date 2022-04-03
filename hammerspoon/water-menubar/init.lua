local function getWaterOunces()
  local date = os.date("%F")
  local file = io.open(os.getenv('HOME') .. '/.daily/items/water/history/' .. date, "rb")

  if file then
    local contents = file:read("*a")
    file:close()

    return tonumber(contents, 10)
  else
    return 0
  end
end

waterMenu = hs.menubar.new()
waterMenu:setIcon(hs.image.imageFromPath(os.getenv('HOME') .. '/.hammerspoon/water-menubar/water-glass.png'))

local function refreshWaterMenu()
  waterMenu:setTitle("" .. getWaterOunces() .. " oz")
end

-- Set it once
refreshWaterMenu()

-- Refresh every 5 seconds
waterRefresh = hs.timer.doEvery(5, refreshWaterMenu)
