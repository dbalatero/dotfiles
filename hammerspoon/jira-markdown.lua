local function convertMarkdownToConfluence()
  local originalClipboardContents = hs.pasteboard.getContents()

  hs.alert.show("Converting from Markdown...")

  -- Select all
  hs.eventtap.keyStroke({ "cmd" }, "a", 0)

  -- Get the current change count of the clipboard
  local changeCount = hs.pasteboard.changeCount()

  -- Cut to clipboard
  hs.eventtap.keyStroke({ "cmd" }, "c", 0)

  -- Wait for the clipboard to have the <textarea> contents.
  clipboardHasUpdated = function()
    return changeCount ~= hs.pasteboard.changeCount()
  end

  local clipboardTimer = hs.timer.waitUntil(clipboardHasUpdated, function()
    -- Get the markdown out of the clipboard
    local markdown = hs.pasteboard.getContents()

    -- Write it to a file
    local file = io.open("/tmp/jira.md", "w+")
    io.output(file)
    io.write(markdown)
    io.close(file)

    -- Run it through md2confl
    local binPath = os.getenv("HOME") .. "/go/bin/md2confl"
    local result = hs.execute("cat /tmp/jira.md | " .. binPath)

    -- Trim whitespace
    result = string.gsub(result, "^%s*(.-)%s*$", "%1")

    local lines = hs.fnutils.split(result, "\n", nil, true)

    for index, line in ipairs(lines) do
      hs.eventtap.keyStrokes(line)

      if index < #lines then
        hs.eventtap.keyStroke({}, "return", 0)
      end
    end

    hs.alert.show("Done!")

    -- Restore clipboard
    hs.pasteboard.setContents(originalClipboardContents)
  end)

  hs.timer.doAfter(3, function()
    -- Give up if the clipboard doesn't update after 3 seconds.
    clipboardTimer:stop()
  end)
end

hyperKey:bind("x"):toFunction("Markdown -> JIRA", convertMarkdownToConfluence)
