-- Shows a macOS menubar item with how much water I've drank today.
-- Uses my `bin/daily` script to get the values.

waterMenu = hs.menubar.new()

local function refreshWaterMenu()
  -- Get the current ounces from `daily water show`
  local task = hs.task.new(os.getenv('HOME') .. '/.nix-profile/bin/daily', function(_, stdout)
    ounces = string.gsub(stdout, '%s$', '') -- strip the \n off the output
    waterMenu:setTitle(' ' .. ounces .. ' oz')
  end, {
    'water',
    'show',
  })

  task:start()
end

-- Init the menu
waterMenu:setIcon(hs.image.imageFromPath(os.getenv('HOME') .. '/.hammerspoon/water-menubar/water-glass.png'))
waterMenu:setTitle('...') -- Loading

-- Read the first value immediately
refreshWaterMenu()

-- Refresh the menu every 5 seconds
waterRefresh = hs.timer.doEvery(5, refreshWaterMenu)
