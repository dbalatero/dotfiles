inspect = hs.inspect.inspect

hs.application.enableSpotlightForNameSearches(true)

require("hs.ipc")
hs.loadSpoon("EmmyLua")

require("common")
require("nytimes")
require("quick-switch")
require("config-watch")
require("window-hotkeys")
require("key-bindings")
require("mute-on-sleep")
require("audio-switcher")
require("slack")
require("pairing-mode")
require("experimental")
require("contextual-modal")
require("headphones")
require("monitor-switching")
require("ocr-paste")
require("zoom")
-- require "text-expander"
require("course")
-- require "autocomplete"
require("jira-markdown")
require("read-later")
-- require("pull-request-comments")
require("paste-code-to-gdocs")
require("keys-pressed")
-- require("water-menubar")
-- require "good-morning-obsidian"
require("code-screen-recorder")
require("domain-swappin")

local SkyRocket = hs.loadSpoon("SkyRocket")

sky = SkyRocket:new({
  disabledApps = { "Alacritty", "kitty", "iTerm2" },

  -- Which modifiers to hold to move a window?
  moveModifiers = { "cmd", "shift" },

  -- Which modifiers to hold to resize a window?
  resizeModifiers = { "ctrl", "shift" },
})

-- Require private hammerspoon config if exists
pcall(require, "private.init")

-- only do vim3 dev on my desktop
if hs.host.localizedName() == "sorny" then
  -- require "vim3"
  require("vim-mode")
end

if hs.host.localizedName() == "st-dbalatero1" then
  require("vim-mode")
end

require("spotify")
require("rich-link-copy")
require("qmk-layer-indicator")

-- Testing for course
-- local WhichKey = require('which-key')
-- local cmdKey = WhichKey:new({'cmd'})
-- cmdKey:bind('t'):toFunction('Hi', function() hs.alert.show('hi') end)

hs.hotkey.bind(hyper, "7", function()
  hs.eventtap.keyStroke({ "cmd" }, "l")
  hs.eventtap.keyStrokes("https://admin.corp.stripe.com/migrations/new", 0)
  hs.eventtap.keyStroke({}, "return", 0)
end)

hs.hotkey.bind(hyper, "8", function()
  hs.eventtap.keyStrokes(
    "replace_shipment_references_with_shipping_rate_references"
  )
  hs.eventtap.keyStroke({}, "return", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({}, "tab", 0)
  hs.eventtap.keyStroke({ "cmd" }, "v", 0)
end)

-- Require private hammerspoon config if exists
pcall(dofile, os.getenv("HOME") .. "/.hammerspoon_experiments.lua")
