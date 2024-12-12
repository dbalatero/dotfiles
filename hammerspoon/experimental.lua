local logger = hs.logger.new('explore', 'debug')
local ax = require('hs.axuielement')

local function withMeasurement(name, fn)
  local logger = hs.logger.new('timer', 'debug')

  local startTime = hs.timer.absoluteTime()

  fn()

  local endTime = hs.timer.absoluteTime()

  local diffNs = endTime - startTime
  local diffMs = diffNs / 1000000

  logger.i(name .. 'took: ' .. diffMs .. 'ms')
end

function getCurrentSelection()
  local elem = hs.uielement.focusedElement()
  local sel = nil

  if elem then
    sel = elem:selectedText()
  end

  -- fallback to copy
  if (not sel) or (sel == '') then
    hs.eventtap.keyStroke({ 'cmd' }, 'c')
    hs.timer.usleep(20000)
    sel = hs.pasteboard.getContents()
  end

  return (sel or '')
end

function getCurrentPositionAsync(callbackFn)
  local logger = hs.logger.new('timer', 'debug')
  local startTimeNs = hs.timer.absoluteTime()

  local reportCallback = function(position)
    local endTimeNs = hs.timer.absoluteTime()
    local diffMs = (endTimeNs - startTimeNs) / 1000000

    logger.i('Got position in millseconds: ' .. position, diffMs)

    callbackFn(position)
  end

  local systemElement = ax.systemWideElement()
  local currentElement = systemElement:attributeValue('AXFocusedUIElement')
  local initialValue = currentElement:attributeValue('AXValue')

  -- If empty, we know we can return early with 0
  if initialValue == '' then
    return reportCallback(0)
  end

  local currentValue = initialValue

  local valueChanged = function()
    currentValue = currentElement:attributeValue('AXValue')
    return currentValue ~= initialValue
  end

  -- check every 0.2ms for a value change
  local waitInterval = 0.2 / 1000

  local changeTimer = hs.timer.waitUntil(valueChanged, function()
    local position = string.len(currentValue)
    reportCallback(position)

    withMeasurement('restore value', function()
      -- restore the value
      hs.eventtap.keyStroke({ 'cmd' }, 'z', 0)
      hs.eventtap.keyStroke({}, 'left', 0)
    end)
  end, waitInterval)

  -- how long are we willing to wait for the value before
  -- timing out and aborting?
  local maxWaitTimeSecs = 50 / 1000 -- 500ms

  hs.timer.doAfter(maxWaitTimeSecs, function()
    if changeTimer:running() then
      changeTimer:stop()
      callbackFn(string.len(initialValue))
    end
  end)

  -- kick it off
  hs.eventtap.keyStroke({ 'cmd', 'shift' }, 'down', 0)

  -- fire delete after 2ms
  hs.timer.doAfter(5 / 1000, function()
    hs.eventtap.keyStroke({}, 'forwarddelete', 0)
  end)
end

-- hs.hotkey.bind(super, 'u', function()
--   getCurrentPositionAsync(function(position)
--     logger.i("Got position " .. inspect(position))
--   end)
-- end)

hs.hotkey.bind(super, '9', function()
  local startTimeNs = hs.timer.absoluteTime()
  local initialCount = hs.pasteboard.changeCount()
  local pasteboardTimer
  local timeoutTimer

  -- the clipboard has updated with a new value once the count changes
  local clipboardHasUpdated = function()
    return initialCount ~= hs.pasteboard.changeCount()
  end

  -- wait for the pasteboard to increment its count, indicating that
  -- the async copy to clipboard is done
  local waitInterval = 10 / 1000 -- 10ms

  -- select to the left
  hs.eventtap.keyStroke({ 'cmd', 'shift' }, 'left', 0)

  -- fire copy after 10ms
  hs.timer.doAfter(10 / 1000, function()
    hs.eventtap.keyStroke({ 'cmd' }, 'c', 0)
  end)

  pasteboardTimer = hs.timer.waitUntil(clipboardHasUpdated, function()
    local contents = hs.pasteboard.getContents()

    local endTimeNs = hs.timer.absoluteTime()
    local diffMs = (endTimeNs - startTimeNs) / 1000000

    logger.i('Got contents in millseconds: ' .. contents, diffMs)
    logger.i('Cursor position: ' .. string.len(contents))
  end, waitInterval)
end)

hs.hotkey.bind(super, '8', function()
  local startTimeNs = hs.timer.absoluteTime()
  local initialCount = hs.pasteboard.changeCount()
  local pasteboardTimer
  local timeoutTimer

  -- the clipboard has updated with a new value once the count changes
  local clipboardHasUpdated = function()
    return initialCount ~= hs.pasteboard.changeCount()
  end

  -- wait for the pasteboard to increment its count, indicating that
  -- the async copy to clipboard is done
  local waitTimeSecs = 10 / 1000 -- 10ms

  -- fire copy
  hs.eventtap.keyStroke({ 'cmd' }, 'c')

  pasteboardTimer = hs.timer.waitUntil(clipboardHasUpdated, function()
    if timeoutTimer and timeoutTimer:running() then
      timeoutTimer:stop()
    end

    local endTimeNs = hs.timer.absoluteTime()
    local diffMs = (endTimeNs - startTimeNs) / 1000000

    logger.i('Got contents in millseconds: ', diffMs)

    -- call our callback with the pasteboard contents
    callbackFn(hs.pasteboard.getContents())
  end, waitTimeSecs)

  -- how long are we willing to wait for the clipboard before
  -- timing out and aborting?
  local maxWaitTimeSecs = 500 / 1000 -- 500ms

  hs.timer.doAfter(maxWaitTimeSecs, function()
    if pasteboardTimer:running() then
      pasteboardTimer:stop()
      callbackFn(nil)
    end
  end)
end)

function getForwardContents()
  hs.eventtap.keyStroke({ 'cmd', 'shift' }, 'down', 0)
  local contents = getCurrentSelection()
  hs.eventtap.keyStroke({}, 'left')

  logger.i(contents)
end

function setFieldValue()
  local systemElement = ax.systemWideElement()
  local currentElement = systemElement:attributeValue('AXFocusedUIElement')

  -- currentElement:setValue("hahhaahaha")

  local value = 'from pasteboard'
  hs.pasteboard.setContents(value)

  -- local systemElement = ax.systemWideElement()
  -- local currentElement = systemElement:attributeValue("AXFocusedUIElement")

  -- local length = currentElement:numberOfCharacters()
  -- currentElement:setSelectedTextRange({ location = 0, length = length })
  -- currentElement:setSelectedText("from pasteboard")
end

-- hs.hotkey.bind(hyper, 'r', setFieldValue)

-- hs.hotkey.bind(super, 'u', function()
--   local systemElement = ax.systemWideElement()
--   local currentElement = systemElement:attributeValue("AXFocusedUIElement")

--   withMeasurement('retrieving value', function()
--     currentElement:attributeValue('AXValue')
--   end)

--   withMeasurement('retrieving position', function()
--     currentElement:attributeValue('AXSelectedTextRange')
--   end)

--   withMeasurement('setting value', function()
--     currentElement:setValue('blah')
--   end)

--   withMeasurement('setting position', function()
--     currentElement:setSelectedTextRange({ location = 0, length = 3 })
--   end)
-- end)

function getCursorPositionManually()
  local startTime = hs.timer.absoluteTime()
  local systemElement = ax.systemWideElement()
  local currentElement = systemElement:attributeValue('AXFocusedUIElement')

  local startValue = currentElement:attributeValue('AXValue')
  hs.eventtap.keyStroke({}, 'delete', 0)

  local deletedValue = nil

  local predicate = function()
    deletedValue = currentElement:attributeValue('AXValue')
    return deletedValue ~= startValue
  end

  hs.timer.waitUntil(predicate, function()
    hs.eventtap.keyStroke({ 'cmd' }, 'z', 0)

    local endTime = hs.timer.absoluteTime()

    local diffNs = endTime - startTime
    local diffMs = diffNs / 1000000

    logger.i('first value:')
    logger.i(inspect(startValue))

    logger.i('second value:')
    logger.i(inspect(deletedValue))

    logger.i('took: ' .. diffMs .. 'ms')
  end)
end

hs.hotkey.bind(hyper, '2', getCursorPositionManually)

function debugElement(currentElement)
  local role = currentElement:attributeValue('AXRole')

  if role == 'AXTextField' or role == 'AXTextArea' or role == 'AXComboBox' then
    logger.i('Currently in text field')
    logger.i(inspect(currentElement:parameterizedAttributeNames()))

    logger.i('param attributes:')
    logger.i('-----------')
    for _, name in ipairs(currentElement:parameterizedAttributeNames()) do
      logger.i(name .. ': ' .. inspect(currentElement:parameterizedAttributeValue(name, {})))
    end

    logger.i('attributes:')
    logger.i('-----------')
    -- p("AXTextMarkerForPosition: " .. inspect(currentElement:parameterizedAttributeValue("AXTextMarkerForPosition", {})))

    local attributes = currentElement:allAttributeValues()

    local names = {}
    for name in pairs(attributes) do
      table.insert(names, name)
    end
    table.sort(names)

    for _, name in ipairs(names) do
      logger.i('  ' .. name .. ': ' .. inspect(attributes[name]))
    end

    logger.i('action names:')
    local names = currentElement:actionNames()
    logger.i(inspect(names))
    logger.i('action descriptions:')
    logger.i('--------------------')

    for _, name in ipairs(names) do
      logger.i('  ' .. name .. ': ' .. currentElement:actionDescription(name))
    end

    logger.i('\n')

    logger.i('Children:' .. inspect(currentElement:attributeValue('AXChildren')))

    -- local attempt = {
    --   'subrole',
    --   'editableAncestor',
    --   'dOMClassList',
    --   'dOMIdentifier',
    --   'description',
    --   'roleDescription',
    -- }
  else
    logger.i('Role = ' .. role)
  end
end

currentAxElement = function()
  local systemElement = ax.systemWideElement()
  return systemElement:attributeValue('AXFocusedUIElement')
end

intervalTimer = nil

hs.hotkey.bind(super, 'e', function()
  -- draw a black rectangle in the bounding box with 20% opacity
  local canvas = hs.canvas.new({ x = 0, y = 0, h = 1, w = 1 })

  canvas:level('overlay')

  -- block caret
  canvas:insertElement({
    type = 'rectangle',
    action = 'fill',
    fillColor = { red = 0, green = 0, blue = 0, alpha = 0.2 },
    frame = { x = '0%', y = '0%', h = '100%', w = '100%' },
    withShadow = false,
  }, 1)

  -- cursor disabler
  local cursorDisableCanvas = hs.canvas.new({ x = 0, y = 0, h = 1, w = 1 })

  cursorDisableCanvas:insertElement({
    type = 'rectangle',
    action = 'fill',
    fillColor = { red = 255, green = 0, blue = 0, alpha = 1 },
    frame = { x = '0%', y = '0%', h = '100%', w = '100%' },
    withShadow = false,
  }, 1)

  local repositionCursor = function()
    local currentElement = currentAxElement()

    -- Get the background color
    local screenshotOfTextInput = hs.screen.mainScreen():snapshot(currentElement:attributeValue('AXFrame'))
    local color = screenshotOfTextInput:colorAt({ x = 10, y = 10 })

    -- Get the current selection
    local range = currentElement:attributeValue('AXSelectedTextRange')

    -- Last visible char
    local visibleRange = currentElement:attributeValue('AXVisibleCharacterRange')
    local lastVisibleIndex = visibleRange.length + visibleRange.location

    if range.location == lastVisibleIndex then
      -- hide the caret if we're at the end of the text box
      canvas:hide()
      cursorDisableCanvas:hide()
    else
      -- Get the range for the next character after the blinking cursor
      local caretRange = {
        location = range.location,
        length = 1,
      }

      -- get the { h, w, x, y } bounding box for the next character's range
      local bounds = currentElement:parameterizedAttributeValue('AXBoundsForRange', caretRange)

      -- move the position and resize
      canvas:topLeft({ x = bounds.x, y = bounds.y })
      canvas:size({ h = bounds.h, w = bounds.w })

      -- show if not shown
      canvas:show()

      -- disable the cursor
      cursorDisableCanvas:topLeft({ x = bounds.x - 1, y = bounds.y })
      cursorDisableCanvas:size({ h = bounds.h, w = 2 })
      cursorDisableCanvas:elementAttribute(1, 'fillColor', color)

      cursorDisableCanvas:show()
    end
  end

  repositionCursor()

  refresh = 1 / 60 -- 60fps
  intervalTimer = hs.timer.doEvery(refresh, repositionCursor)
end)

hs.hotkey.bind(super, 'd', function()
  local systemElement = ax.systemWideElement()
  local currentElement = systemElement:attributeValue('AXFocusedUIElement')

  debugElement(currentElement)

  ancestorFn = currentElement['editableAncestor']

  if ancestorFn then
    logger.i('============================ ancestor\n')
    -- debugElement(ancestorFn(currentElement))
    local ancestor = currentElement:attributeValue('AXFocusableAncestor')
    debugElement(ancestor)

    ancestor:replaceRangeWithTextWithParameter('123')
  end
end)

function debugField(currentElement, fieldName)
  local field = currentElement:attributeValue(fieldName)

  if field then
    logger.i(
      '\n=====================================\ndebugging field '
        .. fieldName
        .. '\n================================================='
    )
    debugElement(field)
  end
end

function getSelectedTextRange()
  -- for now force manual accessibility on
  local axApp = ax.applicationElement(hs.application.frontmostApplication())
  axApp:setAttributeValue('AXManualAccessibility', true)
  -- axApp:setAttributeValue('AXEnhancedUserInterface', true)

  local systemElement = ax.systemWideElement()
  local currentElement = systemElement:attributeValue('AXFocusedUIElement')

  debugElement(currentElement)
  debugField(currentElement, 'AXFocusableAncestor')
  debugField(currentElement, 'AXEditableAncestor')
end

function getChromeUrl()
  local script = 'tell application "Google Chrome"\n' .. '  get URL of active tab of first window\n' .. 'end tell'

  return hs.osascript.applescript(script)
end

function hasCurrentSelection()
  local currentApp = ax.applicationElement(hs.application.frontmostApplication())
  local menuBar = hs.fnutils.find(currentApp:attributeValue('AXChildren'), function(childElement)
    return childElement:attributeValue('AXRole') == 'AXMenuBar'
  end)

  local menuItems = menuBar:attributeValue('AXChildren')

  local editMenu = hs.fnutils.find(menuItems, function(menuItem)
    return menuItem:attributeValue('AXTitle') == 'Edit'
  end)

  local editItems = editMenu:attributeValue('AXChildren')[1]:attributeValue('AXChildren')

  local copyItem = hs.fnutils.find(editItems, function(editItem)
    return editItem:attributeValue('AXTitle') == 'Copy'
  end)

  local isEnabled = copyItem:attributeValue('AXEnabled')

  return isEnabled
end

function drawBoxAbove(xPos, yPos)
  local width = 125
  local height = 25

  local nudge = 3
  local x = xPos - nudge
  local y = yPos - height - nudge

  local canvas = hs.canvas.new({ w = width, h = height, x = x, y = y })

  canvas:appendElements({
    type = 'rectangle',
    action = 'fill',
    roundedRectRadii = { xRadius = 2, yRadius = 2 },
    fillColor = {
      red = 4 / 255,
      green = 135 / 255,
      blue = 250 / 255,
      alpha = 0.95,
    },
    strokeColor = { white = 1.0 },
    strokeWidth = 3.0,
    frame = { x = '0%', y = '0%', h = '100%', w = '100%' },
    withShadow = true,
  }, {
    type = 'text',
    action = 'fill',
    frame = {
      x = '5%',
      y = '10%',
      h = '100%',
      w = '95%',
    },
    text = hs.styledtext.new('NORMAL', {
      font = { name = 'Courier New Bold', size = 14 },
      color = { white = 1.0 },
    }),
  })

  canvas:show()
end

hs.hotkey.bind(hyper, '0', function()
  local systemElement = ax.systemWideElement()
  local currentElement = systemElement:attributeValue('AXFocusedUIElement')
  local position = currentElement:position()

  drawBoxAbove(position.x, position.y)
end)

hs.hotkey.bind(hyper, '5', function()
  -- logger.i("Selection enabled", hasCurrentSelection())
  getSelectedTextRange()
end)

function printAXNotifications(ae, o)
  processChildren = function(child)
    failureCount = 0
    failures = ''

    for i, notification in pairs(ax.observer.notifications) do
      local status, err = pcall(function()
        o:addWatcher(child, notification)
      end)
      if not status then
        failureCount = failureCount + 1
        if i == #ax.observer.notifications then
          failures = failures .. notification
        else
          failures = failures .. notification .. ', '
        end
      end
    end

    if failureCount == 0 then
      print(string.format('All notifications available for: %s', child))
    else
      if failureCount == #ax.observer.notifications then
        print(string.format('ERROR: All notifications unavailable for: %s', child))
      else
        print(string.format('ERROR: Some notifications unavailable for: %s (%s)', child, failures))
      end
    end

    children = child:attributeValue('AXChildren')
    if children and #children > 0 then
      for _, v in pairs(children) do
        processChildren(v)
      end
    end
  end

  rootChildren = ae:attributeValue('AXChildren')
  if #rootChildren > 0 then
    print(string.format('PROCESSING: %s', app))
    print('--------------------------------------')
    for i, v in pairs(rootChildren) do
      processChildren(v)
    end
  else
    print('ERROR: There are no root children in application, so aborting.')
  end
end

-- registering all application focus events

local applicationWatchers = {}

function registerApplicationWatcher(app)
  if not app then
    return
  end
  if applicationWatchers[app:pid()] then
    return
  end

  logger.i('Registering ' .. app:name() .. ' with pid ' .. app:pid())

  local element = ax.applicationElementForPID(app:pid())
  element:setAttributeValue('AXManualAccessibility', true)

  local observer = ax.observer
    .new(app:pid())
    :callback(function(...)
      print(hs.inspect(table.pack(...), { newline = ' ', indent = '' }))
    end)
    :addWatcher(element, 'AXFocusedUIElementChanged')

  printAXNotifications(element, observer)

  observer:start()

  applicationWatchers[app:pid()] = observer
end

function unregisterApplicationWatcher(app)
  logger.i('Unregistering pid ' .. app:pid())

  local observer = applicationWatchers[app:pid()]

  if observer:isRunning() then
    observer:stop()
  end
  applicationWatchers[app:pid()] = nil
end

local appWatcher = hs.application.watcher.new(function(applicationName, event, hsApplication)
  if event == hs.application.watcher.terminated then
    unregisterApplicationWatcher(hsApplication)
  elseif event ~= hs.application.watcher.launched then
    registerApplicationWatcher(hsApplication)
  end
end)

-- hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'n', function()
--   math.randomseed(os.time())

--   local results = {}
--   local logger = hs.logger.new('move', 'debug')

--   -- We're going to move the current focused window
--   local window = hs.window.focusedWindow()

--   local startTime = hs.timer.absoluteTime()

--   for i = 1, 40 do
--     local loopStart = hs.timer.absoluteTime()

--     local dx = -1 * math.random(2, 15) -- move left a random number of px
--     local dy = -1 * math.random(0, 2) -- nudge up a bit randomly

--     local moveStart = hs.timer.absoluteTime()

--     local frame = window:frame()

--     window:setTopLeft({
--       frame.x + dx,
--       frame.y + dy
--     })

--     local moveEnd = hs.timer.absoluteTime()

--     table.insert(results, {
--       dx = dx,
--       dy = dy,
--       start = loopStart,
--       move = moveEnd - moveStart,
--     })
--   end

--   logger.d("Moved " .. tostring(#results) .. " times:")

--   -- print timing results
--   for i, event in ipairs(results) do
--     local eventMs = (event.start - startTime) / 100000
--     local moveMs = event.move / 100000

--     logger.d("  Event " .. tostring(i) .. ": time = " .. tostring(eventMs) .. "ms, move = " .. moveMs .. "ms, dx = " .. event.dx .. "px, dy = " .. event.dy .. "px")
--   end
-- end)

-- registerApplicationWatcher(hs.application.frontmostApplication())
-- appWatcher:start()
