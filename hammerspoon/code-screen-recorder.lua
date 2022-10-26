-- TODO:
--
--   disable auto close quotes
--   disable auto close brackets
--
-- Our "movie script"
local dummyScript = {
  {
    type = 'type',
    text = "import EdgeImpulse from './index';",
    speed = 'slow',
  },
  { type = "newLine" },
  { type = "newLine" },
  {
    type = 'type',
    text = "const client = new EdgeImpulse({ apiKey: 'ei_yourkey' });",
    speed = 'slow',
  },
  { type = "newLine" },
  { type = "newLine" },
  {
    type = 'type',
    text = "const main = async () => {",
    speed = 'slow',
  },
  { type = "waitForEditor" },
  { type = "newLine" },
  {
    type = 'type',
    speed = 'slow',
    text = "const { projects } = await client.projects.",
  },
  { type = "wait", waitMs = 750 },
  { type = "keyPress", keyName = "down", waitMs = 500 },
  { type = "keyPress", keyName = "return", waitMs = 200 },
  -- open parens
  {
    type = 'type',
    speed = 'slow',
    text = "();",
  },
  { type = "newLine" },
  { type = "newLine" },
  { type = "wait", waitMs = 750 },
  {
    type = 'type',
    text = "projects.forEach((project) => {",
  },
  { type = "newLine" },
  {
    type = 'type',
    speed = 'slow',
    text = "console.log(`- Found project ${project.",
  },
  { type = "wait", waitMs = 500 },
  {
    type = 'type',
    text = "id",
    speed = 'slow',
  },
  { type = "wait", waitMs = 500 },
  { type = "keyPress", keyName = "return" },
  {
    type = 'type',
    speed = 'slow',
    text = "}, description: ${project.desc",
  },
  { type = "wait", waitMs = 500 },
  { type = "keyPress", keyName = "return" },
  {
    type = 'type',
    speed = 'slow',
    text = "}`);",
  },
  { type = "newLine" },
  { type = "wait", waitMs = 200 },
  {
    type = 'type',
    text = "});",
    speed = 'slow',
  },
  { type = "newLine" },
  { type = "wait", waitMs = 200 },
  {
    type = 'type',
    text = "};",
    speed = 'slow',
  },
  { type = "newLine" },
  { type = "newLine" },
  {
    type = 'type',
    text = "main();",
    speed = 'slow',
  },

  -- { type = "keyPress", keyName = "down" },
  -- { type = "keyPress", modifiers = {'ctrl'}, keyName = "e" },
  -- { type = "keyPress", keyName = ";" },
  -- { type = "newLine" },
  -- { type = "keyPress", modifiers = {'cmd'}, keyName = "delete", waitMs = 200 },
  -- {
  --   type = 'type',
  --   text = "};",
  -- },
  -- { type = "newLine" },
  -- { type = "newLine" },
  -- {
  --   type = 'type',
  --   text = "main();",
  -- },
}

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
  type = function(action, nextAction)
    local speed = action.speed or "fast"

    if speed == "slow" then
      local sleepSeconds = 20 / 1000 -- 20ms between each key
      local characters = stringToChars(action.text)

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
          -- done!
          nextAction()
        end
      end

      -- loop thru the characters, waiting between each one.
      handleCharacter()
    else
      hs.eventtap.keyStrokes(action.text)
      nextAction()
    end
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
  runMovieScript(dummyScript)
end)
