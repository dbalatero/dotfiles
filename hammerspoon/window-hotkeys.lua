-- window-management.lua provides all the interesting functions we need to
-- bind these hotkeys
local wm = require('window-management')

superKey
  :bind('c')
  :toFunction('Center window', wm.centerOnScreen)
  :bind('f')
  :toFunction('Maximize (full) window', wm.maximizeWindow)
  :bind('h')
  :toFunction('Send window left', wm.leftHalf)
  :bind('j')
  :toFunction('Send window bottom', wm.bottomHalf)
  :bind('k')
  :toFunction('Send window top', wm.topHalf)
  :bind('l')
  :toFunction('Send window right', wm.rightHalf)
  :bind('n')
  :toFunction('Shrink left', wm.shrinkLeft)
  :bind('m')
  :toFunction('Grow down', wm.growDown)
  :bind(',')
  :toFunction('Shrink up', wm.shrinkUp)
  :bind('.')
  :toFunction('Grow right', wm.growRight)
  :bind('y')
  :toFunction('Nudge left', wm.nudgeLeft)
  :bind('u')
  :toFunction('Nudge down', wm.nudgeDown)
  :bind('i')
  :toFunction('Nudge up', wm.nudgeUp)
  :bind('o')
  :toFunction('Nudge right', wm.nudgeRight)
  :bind('q')
  :toFunction('Throw to left screen', wm.throwLeft)
  :bind('w')
  :toFunction('Throw to right screen', wm.throwRight)

-- Pops the visible Chrome tab into a new browser window next to the current one
local function popoutChromeTabSideBySide()
  -- Move current window to the left half
  wm.leftHalf()

  hs.timer.doAfter(100 / 1000, function()
    -- Pop out the current tab
    hs.application.launchOrFocus('/Applications/Google Chrome.app')

    local chrome = hs.appfinder.appFromName('Google Chrome')
    local moveTab = { 'Tab', 'Move Tab to New Window' }

    chrome:selectMenuItem(moveTab)

    -- Move it to the right of the screen
    wm.rightHalf()
  end)
end

-- Bind this to super + ]
superKey:bind(']'):toFunction('Chrome tab 50-50', popoutChromeTabSideBySide)
