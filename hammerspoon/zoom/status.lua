local statuses = {
  muted = "muted",
  unmuted = "unmuted",
  notMeeting = "notMeeting",
}

statuses.getStatus = function()
  local zoomApp = hs.application.find("zoom.us")

  if not zoomApp or not zoomApp:findMenuItem({ "Meeting", "Fullscreen" }) then
    return statuses.notMeeting
  end

  local script = [[
    property btnTitle : "Mute audio"

    if application "zoom.us" is running then
      tell application "System Events"
        tell application process "zoom.us"
          if exists (menu item btnTitle of menu 1 of menu bar item "Meeting" of menu bar 1) then
            set returnValue to "Unmuted"
          else
            set returnValue to "Muted"
          end if
        end tell
      end tell
    else
      set returnValue to ""
    end if

    return returnValue
  ]]

  local _, value = hs.osascript.applescript(script)

  if value == "Muted" then
    return statuses.muted
  elseif value == "Unmuted" then
    return statuses.unmuted
  else
    return statuses.notMeeting
  end
end

return statuses
