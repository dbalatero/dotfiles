local function getDeviceChoices()
  local devices = hs.audiodevice.allOutputDevices()
  local choices = {}

  for i, device in ipairs(devices) do
    icon = "🔊"

    if device:outputMuted() then
      icon = "🔇"
    end

    local subText = icon

    if device:outputVolume() then
      subText = subText
        .. " Volume "
        .. math.floor(device:outputVolume())
        .. "%"
    end

    choices[i] = {
      text = device:name(),
      subText = subText,
      uuid = device:uid(),
    }
  end

  return choices
end

local function handleAudioChoice(choice)
  if not choice then
    return
  end

  local device = hs.audiodevice.findDeviceByUID(choice["uuid"])
  device:setDefaultOutputDevice()
  device:setOutputMuted(false)

  hs.alert("Switched to " .. choice["text"])
end

----------

local audioChooser = hs.chooser.new(handleAudioChoice)
audioChooser:width(20)

hs.hotkey.bind({ "cmd", "shift" }, "space", function()
  local choices = getDeviceChoices()

  audioChooser:choices(choices)
  audioChooser:show()
end)
