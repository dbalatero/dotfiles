local function wasFileTouchedToday(file)
  local currentTime = os.date('*t', os.time())
  local beginningOfDay = os.time({
    month = currentTime.month,
    day = currentTime.day,
    year = currentTime.year,
    hour = 0,
    min = 0,
    sec = 0,
  })

  local fileAttributes = hs.fs.attributes(file)

  if fileAttributes then
    return fileAttributes.modification > beginningOfDay
  else
    return false
  end
end

local function touchOrCreateFile(file)
  hs.task
    .new(
      '/bin/bash',
      nil,
      function() end, -- noop
      {
        '-c',
        'touch ' .. file,
      }
    )
    :start()
end

local function cycleObsidian()
  local lastRanFile = os.getenv('HOME') .. '/.config/last-obsidian-cycle'

  -- Only cycle the app once per day.
  if wasFileTouchedToday(lastRanFile) then
    return
  end

  -- Touch the modification time.
  touchOrCreateFile(lastRanFile)

  local runningApp = hs.application.find('Obsidian')

  if runningApp then
    runningApp:kill()
  end

  hs.application.open('Obsidian')
end

-- Only load this if Obsidian exists on the machine.
if hs.fs.displayName('/Applications/Obsidian.app') then
  obsidianWatcher = hs.caffeinate.watcher.new(function(state)
    if state == hs.caffeinate.watcher.systemDidWake then
      cycleObsidian()
    end
  end)

  obsidianWatcher:start()
end
