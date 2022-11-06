local inspect = dofile('inspect.lua')
local log = dofile('log.lua')

local logger = {
  i = log.info,
}

local ChildProcessStream = require('nvim.child_process_stream')
local Session = require('nvim.session')

local lines = {
  'First line',
  'Second line',
  'Third line',
}

-- open nvim in headless mode with a blank vimrc
local nvim = Session.new(ChildProcessStream.spawn({
  '/usr/local/bin/nvim',
  '-u',
  'NONE',
  '--embed',
  '--headless',
}))

-- create a scratch buffer in vim
local _, scratchBuffer = nvim:request('nvim_create_buf', false, true)
nvim:request('nvim_win_set_buf', 0, scratchBuffer)

logger.i('setting buffer to: ' .. inspect(lines))

-- set the buffer lines
nvim:request('nvim_buf_set_lines', scratchBuffer, 0, -1, true, lines)

-- print out lines before edit
local ok, updatedLines = nvim:request('nvim_buf_get_lines', scratchBuffer, 0, -1, true)

logger.i('before dw')
logger.i(inspect(updatedLines))

-- put the cursor at line 1, column 0
nvim:request('nvim_win_set_cursor', 0, { 1, 0 })

-- subscribe to events
nvim:request('nvim_buf_attach', scratchBuffer, false, {})

local modeMap = {
  n = 'normal',
  i = 'insert',
  v = 'visual',
}

nvim:request('nvim_feedkeys', 'vw', 'n', false)
_, result = nvim:request('nvim_get_mode')
logger.i('  mode: ' .. inspect(result))

nvim:request('nvim_feedkeys', 'dw', 'n', false)

local function handleNotification(message)
  local type = message[1]
  local eventType = message[2]
  local args = message[3]

  if type ~= 'notification' then
    return
  end

  if eventType == 'nvim_buf_changedtick_event' then
    logger.i('nvim_buf_changedtick_event:')

    local _, result = nvim:request('nvim_get_mode')
    logger.i('  mode: ' .. inspect(result))
    logger.i('  mode: ' .. inspect(modeMap[result['mode']]))

    _, result = nvim:request('nvim_win_get_cursor', 0)
    logger.i('  cursor line:   ' .. inspect(result[1]))
    logger.i('  cursor column: ' .. inspect(result[2]))
  elseif eventType == 'nvim_buf_lines_event' then
    logger.i('nvim_buf_lines_event:')

    local firstLine = args[3]
    local lastLine = args[4]
    local changes = args[5]

    logger.i('  first line changed: ' .. firstLine)
    logger.i('  last line changed: ' .. lastLine)
    logger.i('  changes: ' .. inspect(changes))
  end
end

local message = nvim:next_message(5)
while message do
  handleNotification(message)
  message = nvim:next_message(5)
end

local _, updatedLines = nvim:request('nvim_buf_get_lines', scratchBuffer, 0, -1, true)

logger.i('after dw')
logger.i(inspect(updatedLines))
