local function swapToDomain(domain, protocol)
  return function()
    local application = hs.application.frontmostApplication()

    -- Only swap if focused on Chrome
    if application:bundleID() ~= "com.google.Chrome" then
      return
    end

    local script = [[
      tell application "Google Chrome"
        get URL of active tab of front window
      end tell
    ]]

    -- Swap the domain
    local _, url = hs.osascript.applescript(script)

    if not url then
      return
    end

    local newUrl = url
      :gsub("^https?://", protocol .. "://")
      :gsub("([^/]+)//([^/]+)", "%1//" .. domain)

    local updateScript = [[
      const chrome = Application('Google Chrome');
      let activeTab = null;
      let minIndex = 99999999999999999;

      chrome.windows().forEach((window) => {
        const index = window.index();

        if (index < minIndex) {
          minIndex = index;
        activeTab = window.activeTab;
        }
      });
    ]]

    updateScript = updateScript .. "\n" .. 'activeTab.url = "' .. newUrl .. '";'
    hs.osascript.javascript(updateScript)
  end
end

-- I use a super special keybind system for jerks
superKey:bind("1"):toFunction(
  "Swap to local devapp",
  swapToDomain("dbalatero-stripejs-demos.tunnel.stripe.me", "https")
)
superKey:bind("2"):toFunction(
  "Swap to staging devapp",
  swapToDomain("stripejsdevapp.corp.stripe.com", "https")
)

superKey
  :bind("3")
  :toFunction(
    "Swap to localhost devapp",
    swapToDomain("localhost:3000", "http")
  )

-- But you can just use this for standard keybinding by uncommenting the
-- following lines & deleting the 2 lines above:
-- (edit your keybindings to taste)

-- hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, '1', swapToDomain('localhost:3000'))
-- hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, '2', swapToDomain('app.stg.graphite.dev'))
