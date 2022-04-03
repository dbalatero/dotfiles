-- Shows a macOS menubar item with how much water I've drank today.
-- Uses my `bin/daily` script to get the values.

waterMenu = hs.menubar.new()
waterMenu:setIcon(hs.image.imageFromPath(os.getenv('HOME') .. '/.hammerspoon/water-menubar/water-glass.png'))
waterMenu:setTitle("...") -- Loading

local function refreshWaterMenu()
  -- Get the current ounces from `daily water show`
  local task = hs.task.new(
    os.getenv('HOME') .. '/.dotfiles/bin/daily',
    function (_, stdout)
      ounces = string.gsub(stdout, "%s$", "")
      waterMenu:setTitle("" .. ounces .. " oz")
    end,
    {
      'water',
      'show',
    }
  )

  task:start()
end

-- Set it once
refreshWaterMenu()

-- Refresh every 5 seconds
waterRefresh = hs.timer.doEvery(5, refreshWaterMenu)
