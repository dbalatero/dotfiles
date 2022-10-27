local function stringToChars(str)
  local chars = {}
  local current = 1

  while current <= #str do
    table.insert(chars, string.sub(str, current, current))
    current = current + 1
  end

  return chars
end

local function eachCharacter(str, fn)
  for _, char in ipairs(stringToChars(str)) do
    fn(char)
  end
end

local characterOverrides = {
  [" "] = {{}, "space"},
  ["!"] = {{'shift'}, '1'},
  ["@"] = {{'shift'}, '2'},
  ["#"] = {{'shift'}, '3'},
  ["$"] = {{'shift'}, '4'},
  ["%"] = {{'shift'}, '5'},
  ["^"] = {{'shift'}, '6'},
  ["&"] = {{'shift'}, '7'},
  ["*"] = {{'shift'}, '8'},
  ["("] = {{'shift'}, '9'},
  [")"] = {{'shift'}, '0'},
  ['"'] = {{'shift'}, "'"},
  [":"] = {{'shift'}, ";"},
  ["+"] = {{'shift'}, '='},
  ["_"] = {{'shift'}, '-'},
  ["<"] = {{'shift'}, ','},
  [">"] = {{'shift'}, '.'},
  ["{"] = {{'shift'}, '['},
  ["}"] = {{'shift'}, ']'},
  ["|"] = {{'shift'}, '\\'},
  ["?"] = {{'shift'}, '/'},
  ["~"] = {{'shift'}, '`'},
}

local function printKeys(characters, options)
  print("Printing: " .. inspect(characters))

  local doneFn = options.doneFn

  -- Default to 20ms between keypresses
  local pauseMilliseconds = options.pauseMilliseconds or 20
  local sleepSeconds = pauseMilliseconds / 1000

  local handleCharacter = nil
  handleCharacter = function()
    -- shift the first one off
    local char = table.remove(characters, 1)

    if char then
      local character = char
      local modifiers = {}

      if characterOverrides[char] then
        modifiers = characterOverrides[char][1] or {}
        character = characterOverrides[char][2]
      end

      if char:find("[A-Z]") then
        table.insert(modifiers, 'shift')
      end

      hs.eventtap.keyStroke(modifiers, character, 0)
      hs.timer.doAfter(sleepSeconds, handleCharacter)
    else
      doneFn()
    end
  end

  -- loop thru the characters, waiting between each one.
  handleCharacter()
end

local function printLine(line, options)
  local newLineAtEnd = options.newLineAtEnd == nil and true or options.newLineAtEnd

  -- Pull out the passed in doneFn so we can wrap it:
  local doneFn = options.doneFn

  options.doneFn = function()
    if newLineAtEnd then
      hs.eventtap.keyStroke({}, 'return', 0)
    end

    hs.timer.doAfter(20 / 1000, doneFn)
  end

  local characters = stringToChars(line)
  printKeys(characters, options)
end

local actionHandlers = {
  keyPress = function(action, nextAction)
    local modifiers = action.modifiers or {}
    hs.eventtap.keyStroke(modifiers, action.keyName, 0)

    if action.waitMs then
      hs.timer.doAfter(action.waitMs / 1000, nextAction)
    else
      nextAction()
    end
  end,
  newLine = function(_action, nextAction)
    hs.eventtap.keyStroke({}, "return", 0)
    nextAction()
  end,
  selectFromAutocomplete = function(action, nextAction)
    local movesBeforeSelect = action.movesBeforeSelect or {}

    local doSelection = function()
      printKeys(movesBeforeSelect, {
        pauseMilliseconds = 270,
        newLineAtEnd = false,
        doneFn = function()
          -- Select autocomplete result
          hs.eventtap.keyStroke({}, "return", 0)

          nextAction()
        end
      })
    end

    if action.narrowResults then
      printKeys(stringToChars(action.narrowResults), {
        pauseMilliseconds = 125, -- type a little slower to show refinements
        newLineAtEnd = false,
        doneFn = function()
          -- Wait before selecting to let them see the refined results.
          hs.timer.doAfter(600 / 1000, doSelection)
        end
      })
    else
      doSelection()
    end
  end,
  type = function(action, nextAction)
    local lines = action.lines

    local afterLastLine = action.afterLastLine or "printNewLine"
    local newLineAfterLastLine = afterLastLine == "printNewLine"

    local handleLine = nil
    handleLine = function()
      local line = table.remove(lines, 1)

      if line then
        local newLineAtEnd = newLineAfterLastLine or #lines > 0

        printLine(line, {
          doneFn = handleLine,
          newLineAtEnd = newLineAtEnd,
        })
      else
        -- Either wait for autocomplete to popup, or immediately fire nextAction.
        local waitTimeout = action.afterLastLine == "waitForAutocomplete" and 750 or 0
        hs.timer.doAfter(waitTimeout / 1000, nextAction)
      end
    end

    handleLine()
  end,
  wait = function(action, nextAction)
    hs.timer.doAfter(action.waitMs / 1000, nextAction)
  end,
  waitForEditor = function(_, nextAction)
    hs.timer.doAfter(500 / 1000, nextAction)
  end
}

local function runMovieScript(movieScript)
  local currentIndex = 0
  local nextAction

  nextAction = function()
    currentIndex = currentIndex + 1

    local action = movieScript[currentIndex]

    if action then
      local handler = actionHandlers[action.type]
      handler(action, nextAction)
    end
  end

  nextAction()
end

hs.hotkey.bind(super, '0', function()
  -- TODO:
  --
  --   disable auto close quotes
  --   disable auto close brackets
  --   disable auto indent
  --
  -- Our "movie script"
  local dummyScript = {
    {
      type = 'type',
      lines = {
        "import EdgeImpulse from './index';",
        "",
        "const client = new EdgeImpulse({ apiKey: 'ei_yourkey' });",
        "",
        "const main = async () => {",
      }
    },
    {
      type = 'type',
      lines = {
        "  const { projects } = await client.projects.",
      },
      afterLastLine = "waitForAutocomplete",
    },
    {
      type = 'selectFromAutocomplete',
      movesBeforeSelect = { 'down' },
    },
    {
      type = 'type',
      lines = {
        "();",
        "",
        "  projects.forEach((project) => {",
        "    console.log(`- Found project ${project.",
      },
      afterLastLine = "waitForAutocomplete",
    },
    {
      type = 'selectFromAutocomplete',
      narrowResults = "id",
    },
    {
      type = 'type',
      lines = { '}, description: ${project.' },
      afterLastLine = "waitForAutocomplete",
    },
    {
      type = 'selectFromAutocomplete',
      narrowResults = "desc",
    },
    {
      type = 'type',
      lines = {
        "}`);",
        "  });",
        "};",
        "",
        "main();",
      },
      afterLastLine = "nothing",
    },
  }

  runMovieScript(dummyScript)
end)
