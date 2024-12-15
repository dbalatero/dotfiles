local ax = require("hs.axuielement")
local table = require("table")

local logger = hs.logger.new("vim3", "debug")

local state = {
  mode = "insert",
}

local ChildProcessStream = require("nvim.child_process_stream")
local Session = require("nvim.session")

function getTextFieldLines(element)
  local range
  local line
  local lines = {}
  local currentLineNumber = 0

  while true do
    range = element:rangeForLineWithParameter(currentLineNumber)

    if range then
      line = element:stringForRangeWithParameter({
        location = range.loc,
        length = range.len,
      })

      table.insert(lines, line)
      currentLineNumber = currentLineNumber + 1
    else
      break
    end
  end

  return lines
end

function makeBuffer()
  local systemElement = ax.systemWideElement()
  local currentElement = systemElement:attributeValue("AXFocusedUIElement")
  local role = currentElement:attributeValue("AXRole")

  if role == "AXTextField" or role == "AXTextArea" then
    -- local lines = {}

    -- if role == "AXTextField" then
    --   local line = currentElement:attributeValue("AXValue")
    --   lines = { line }
    -- else
    --   lines = getTextFieldLines(currentElement)
    -- end

    local lines = {
      "First line",
      "Second line",
      "Third line",
    }

    -- open nvim in headless mode with a blank vimrc
    local nvim = Session.new(ChildProcessStream.spawn({
      "/usr/local/bin/nvim",
      "-u",
      "NONE",
      "--embed",
      "--headless",
    }))

    -- create a scratch buffer in vim
    local _, scratchBuffer = nvim:request("nvim_create_buf", false, true)
    nvim:request("nvim_win_set_buf", 0, scratchBuffer)

    logger.i("attached " .. inspect(ok) .. " " .. inspect(result))

    logger.i("setting: " .. inspect(lines))

    -- set the buffer lines
    nvim:request("nvim_buf_set_lines", scratchBuffer, 0, -1, true, lines)

    -- print out lines before edit
    local ok, updatedLines =
      nvim:request("nvim_buf_get_lines", scratchBuffer, 0, -1, true)

    logger.i("before dd")
    logger.i(inspect(updatedLines))

    -- put the cursor at line 1, column 0
    nvim:request("nvim_win_set_cursor", 0, { 1, 0 })

    -- subscribe to events
    nvim:request("nvim_buf_attach", scratchBuffer, false, {})

    local modeMap = {
      n = "normal",
      i = "insert",
    }

    nvim:request("nvim_feedkeys", "dw", "n", false)

    logger.i(inspect(nvim._pending_messages))

    local _, updatedLines =
      nvim:request("nvim_buf_get_lines", scratchBuffer, 0, -1, true)

    logger.i("after dw")
    logger.i(inspect(updatedLines))

    local _, result = nvim:request("nvim_get_mode")
    logger.i("  mode: " .. inspect(modeMap[result["mode"]]))

    local _, result = nvim:request("nvim_win_get_cursor", 0)
    logger.i("  cursor line:   " .. inspect(result[1]))
    logger.i("  cursor column: " .. inspect(result[2]))

    -- print out lines after
    local function onRequest(method)
      logger.i("==> in onRequest " .. method)
    end

    local function onNotification(method, args)
      logger.i("onNotification(): " .. method)

      if method == "nvim_buf_changedtick_event" then
        nvim:request("nvim_get_mode")
        -- logger.i("  mode: " .. inspect(mode))
      elseif method == "nvim_buf_lines_event" then
        firstLine = args[3]
        lastLine = args[4]

        logger.i("  firstLine: " .. firstLine)
        logger.i("  lastLine: " .. lastLine)
      end
    end

    local function onSetup()
      logger.i("onSetup()")

      -- send a `dd`
      nvim:request("nvim_feedkeys", "dw", "n", false)
      logger.i("stopping")
      nvim:stop()
    end

    -- nvim:run(onRequest, onNotification, onSetup)
  end
end

hs.hotkey.bind(hyper, "2", makeBuffer)
