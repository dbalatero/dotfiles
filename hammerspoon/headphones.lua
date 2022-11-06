local resolvePath = require('utils.resolve-path')

-- Sony WH-1000XM4
local headphoneDeviceId = '94-db-56-47-6a-86'

local blueUtil = resolvePath({
  '/opt/homebrew/bin/blueutil',
  '/usr/local/bin/blueutil',
})

local function disconnectHeadphones()
  hs.task
    .new(blueUtil, function()
      hs.alert('Disconnected headphones')
    end, {
      '--disconnect',
      headphoneDeviceId,
    })
    :start()
end

local function connectHeadphones()
  hs.task
    .new(blueUtil, function()
      hs.alert('Connected headphones')
    end, {
      '--connect',
      headphoneDeviceId,
    })
    :start()
end

local function checkHeadphonesConnected(fn)
  hs.task
    .new(blueUtil, function(_, stdout)
      stdout = string.gsub(stdout, '\n$', '')
      local isConnected = stdout == '1'

      fn(isConnected)
    end, {
      '--is-connected',
      headphoneDeviceId,
    })
    :start()
end

local function toggleHeadphones()
  checkHeadphonesConnected(function(isConnected)
    if isConnected then
      disconnectHeadphones()
    else
      connectHeadphones()
    end
  end)
end

hyperKey:bind('b'):toFunction('Toggle 🎧 connection', toggleHeadphones)
