inspect = hs.inspect.inspect

local VimMode = hs.loadSpoon("VimMode")

require "common"
require "nytimes"
require "quick-switch"
require "config-watch"
require "window-hotkeys"
require "key-bindings"
require "mute-on-sleep"
require "audio-switcher"
require "slack"
require "pairing-mode"
require "experimental"
require "contextual-modal"
require "headphones"
require "monitor-switching"
require "ocr-paste"
require "zoom"
-- require "text-expander"
require "course"
-- require "autocomplete"
require "jira-markdown"
require "read-later"
require "pull-request-comments"
require "paste-code-to-gdocs"
require "keys-pressed"

local SkyRocket = hs.loadSpoon("SkyRocket")

sky = SkyRocket:new({
  disabledApps = {'Alacritty', 'iTerm2'},

  -- Which modifiers to hold to move a window?
  moveModifiers = {'cmd', 'shift'},

  -- Which modifiers to hold to resize a window?
  resizeModifiers = {'ctrl', 'shift'},
})

-- Require private hammerspoon config if exists
pcall(require, "private.init")

-- only do vim3 dev on my desktop
if hs.host.localizedName() == "sorny" then
  -- require "vim3"
end

require "spotify"
require "github"
require "rich-link-copy"
require "qmk-layer-indicator"

-- Testing for course
-- local WhichKey = require('which-key')
-- local cmdKey = WhichKey:new({'cmd'})
-- cmdKey:bind('t'):toFunction('Hi', function() hs.alert.show('hi') end)

local vim = VimMode:new()

hs.chooser.globalCallback = function(chooser, eventName)
  hs.chooser._defaultGlobalCallback(chooser, eventName)

  if eventName == "willOpen" then
    vim:disable()
  else
    vim:enable()
  end
end

-- Configure apps you do *not* want Vim mode enabled in
-- For example, you don't want this plugin overriding your control of Terminal
-- vim
vim
  :disableForApp('Alacritty')
  :disableForApp('Obsidian')
  :disableForApp('Code')
  :disableForApp('Terminal')
  :disableForApp('Tuple')
  :disableForApp('Visual Studio Code')
  :disableForApp('iTerm')
  :disableForApp('iTerm2')
  :disableForApp('zoom.us')
  :disableForApp('IntelliJ IDEA')

vim:enableBetaFeature('block_cursor_overlay')

vim:enableBetaFeature('fallback_only_urls')
vim:setFallbackOnlyUrlPatterns({
  "docs.google.com",
})

hs.hotkey.bind(hyper, '7', function()
  hs.eventtap.keyStroke({'cmd'}, 'l')
  hs.eventtap.keyStrokes("https://admin.corp.stripe.com/migrations/new", 0)
  hs.eventtap.keyStroke({}, "return", 0)
end)

hs.hotkey.bind(hyper, '8', function()
  hs.eventtap.keyStrokes("replace_shipment_references_with_shipping_rate_references")
  hs.eventtap.keyStroke({}, "return", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({'cmd'}, "v", 0)
end)

-- If you want the screen to dim (a la Flux) when you enter normal mode
-- flip this to true.
vim:shouldDimScreenInNormalMode(false)

-- If you want to show an on-screen alert when you enter normal mode, set
-- this to true
vim:shouldShowAlertInNormalMode(true)

vim:setAlertFont("InconsolataGo Bold Nerd Font Complete")

-- Enter normal mode by typing a key sequence
vim:enterWithSequence('jk', 100)
-- if you want to bind a single key to entering vim, remove the
-- :enterWithSequence('jk') line above and uncomment the bindHotKeys line
-- below:
--
-- To customize the hot key you want, see the mods and key parameters at:
--   https://www.hammerspoon.org/docs/hs.hotkey.html#bind
--
-- vim:bindHotKeys({ enter = { {'ctrl'}, ';' } })
--------------------------------
-- END VIM CONFIG
--------------------------------
--

hyperKey:bind('2'):toFunction(
  'Test accessibility',
  VimMode.utils.debug.testAccessibilityField
)
