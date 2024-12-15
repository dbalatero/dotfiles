local function isRunningBigSur()
  -- This command returns a string like "10.14.6" or "11.4.1"
  local result = hs.execute("sw_vers -productVersion")

  -- Check if the version starts with "11" - if so, we're on Big Sur.
  return result:sub(1, 2) == "11"
end

local function enableDoNotDisturbBigSur()
  hs.osascript.applescript([[
set checkboxName to "Do Not
Disturb"

tell application "System Events"
  click menu bar item "Control Center" of menu bar 1 of application process "ControlCenter"
  delay 0.1

  set isChecked to (value of checkbox checkboxName of group 1 of group 1 of window "Control Center" of application process "ControlCenter")

  if not (isChecked as boolean) then
    click checkbox checkboxName of group 1 of group 1 of window "Control Center" of application process "ControlCenter"
    delay 0.1
  end if

  click menu bar item "Control Center" of menu bar 1 of application process "ControlCenter"
end tell
    ]])
end

local function enableDoNotDisturb()
  if isRunningBigSur() then
    enableDoNotDisturbBigSur()
  else
    local commands = {
      "defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true",
      'defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturbDate -date "`date -u +"%Y-%m-%d %H:%M:%S +000"`"',
      "killall NotificationCenter",
    }

    hs.execute(table.concat(commands, " && "))
  end
end

local function enablePairingMode()
  enableDoNotDisturb()

  -- close embarrassing personal apps
  hs.execute("killall Messages")
  hs.execute("killall Signal")

  hs.alert.show("Entering pairing mode")
end

hyperKey:bind("p"):toFunction("Enable pairing mode", enablePairingMode)
