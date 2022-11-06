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
  [' '] = { {}, 'space' },
  ['!'] = { { 'shift' }, '1' },
  ['@'] = { { 'shift' }, '2' },
  ['#'] = { { 'shift' }, '3' },
  ['$'] = { { 'shift' }, '4' },
  ['%'] = { { 'shift' }, '5' },
  ['^'] = { { 'shift' }, '6' },
  ['&'] = { { 'shift' }, '7' },
  ['*'] = { { 'shift' }, '8' },
  ['('] = { { 'shift' }, '9' },
  [')'] = { { 'shift' }, '0' },
  ['"'] = { { 'shift' }, "'" },
  [':'] = { { 'shift' }, ';' },
  ['+'] = { { 'shift' }, '=' },
  ['_'] = { { 'shift' }, '-' },
  ['<'] = { { 'shift' }, ',' },
  ['>'] = { { 'shift' }, '.' },
  ['{'] = { { 'shift' }, '[' },
  ['}'] = { { 'shift' }, ']' },
  ['|'] = { { 'shift' }, '\\' },
  ['?'] = { { 'shift' }, '/' },
  ['~'] = { { 'shift' }, '`' },
}

local function printKeys(characters, options)
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

      if char:find('[A-Z]') then
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
  print('printing: ' .. line)

  local newLineAtEnd = options.newLineAtEnd == nil and true or options.newLineAtEnd

  -- Pull out the passed in doneFn so we can wrap it:
  local doneFn = options.doneFn

  options.doneFn = function()
    hs.timer.doAfter(150 / 1000, function()
      if newLineAtEnd then
        hs.eventtap.keyStroke({}, 'return', 0)
      end

      doneFn()
    end)
  end

  local characters = stringToChars(line)
  printKeys(characters, options)
end

local function triggerCompletions()
  hs.eventtap.keyStroke({ 'ctrl' }, 'space', 0)
end

local actionHandlers = {
  closeHoverBox = function(_, nextAction)
    hs.eventtap.keyStroke({}, 'escape', 0)
    hs.timer.doAfter(50 / 1000, nextAction)
  end,
  hoverDocumentation = function(_, nextAction)
    -- cmd+k cmd+i is hover docs by default in VSCode
    hs.eventtap.keyStroke({ 'cmd' }, 'k', 50)
    hs.eventtap.keyStroke({ 'cmd' }, 'i', 50)
    hs.timer.doAfter(50 / 1000, nextAction)
  end,
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
    hs.eventtap.keyStroke({}, 'return', 0)
    nextAction()
  end,
  saveFile = function(_action, nextAction)
    hs.eventtap.keyStroke({ 'cmd' }, 's', 0)
    nextAction()
  end,
  selectFromAutocomplete = function(action, nextAction)
    if action.triggerCompletions or action.triggerCompletions == nil then
      triggerCompletions()
    end

    local movesBeforeSelect = action.movesBeforeSelect or {}

    local doSelection = function()
      printKeys(movesBeforeSelect, {
        pauseMilliseconds = 150,
        newLineAtEnd = false,
        doneFn = function()
          -- Select autocomplete result
          hs.eventtap.keyStroke({}, 'return', 0)
          nextAction()
        end,
      })
    end

    if action.narrowResults then
      printKeys(stringToChars(action.narrowResults), {
        pauseMilliseconds = 50, -- type a little slower to show refinements
        newLineAtEnd = false,
        doneFn = function()
          -- Wait before selecting to let them see the refined results.
          hs.timer.doAfter(300 / 1000, doSelection)
        end,
      })
    else
      doSelection()
    end
  end,
  triggerCompletions = function(_, nextAction)
    triggerCompletions()
    nextAction()
  end,
  type = function(action, nextAction)
    -- If we want instant typing, set { typingSpeed = 'instant' } in the action,
    -- otherwise default to normal typing speed.
    local lines = action.lines

    local afterLastLine = action.afterLastLine or 'printNewLine'
    local newLineAfterLastLine = afterLastLine == 'printNewLine'

    local handleLine = nil
    handleLine = function()
      local line = table.remove(lines, 1)

      if line then
        local newLineAtEnd = newLineAfterLastLine or #lines > 0

        if action.typingSpeed == 'instant' then
          hs.eventtap.keyStrokes(line)
          hs.timer.doAfter(100 / 1000, function()
            if newLineAtEnd then
              hs.eventtap.keyStroke({}, 'return', 0)
            end
            handleLine()
          end)
        else
          printLine(line, {
            doneFn = handleLine,
            newLineAtEnd = newLineAtEnd,
          })
        end
      else
        -- Either wait for autocomplete to popup, or immediately fire nextAction.
        local waitTimeout = action.afterLastLine == 'waitForAutocomplete' and 750 or 0
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
  end,
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
  local dummyScript = {
    {
      type = 'type',
      lines = {
        "import Mux from 'mux';",
        '',
        'const mux = new Mux({',
        '  // These are dev env values',
        '  tokenId: "<your api token>",',
        '  tokenSecret: "<your api secret>",',
        '});',
        '',
        'async function main() {',
      },
      typingSpeed = 'instant',
    },
    {
      type = 'type',
      lines = {
        '  const asset = await mux.video.',
      },
      afterLastLine = 'waitForAutocomplete',
    },
    {
      type = 'type',
      lines = {
        'as',
      },
      afterLastLine = 'nothing',
    },
    { type = 'wait', waitMs = 200 },
    { type = 'selectFromAutocomplete' },
    {
      type = 'type',
      lines = {
        '.',
      },
      afterLastLine = 'waitForAutocomplete',
    },
    {
      type = 'selectFromAutocomplete',
      narrowResults = 'cre',
    },
    { type = 'wait', waitMs = 200 },
    { type = 'hoverDocumentation' },
    { type = 'wait', waitMs = 1800 },
    { type = 'closeHoverBox' },
    {
      type = 'type',
      lines = {
        '({',
        '    ',
      },
      afterLastLine = 'nothing',
    },
    { type = 'triggerCompletions' },
    {
      type = 'type',
      lines = { 'input' },
      afterLastLine = 'nothing',
    },
    { type = 'wait', waitMs = 200 },
    { type = 'selectFromAutocomplete' },
    { type = 'wait', waitMs = 200 },
    { type = 'closeHoverBox' },
    { type = 'hoverDocumentation' },
    { type = 'wait', waitMs = 3000 },
    {
      type = 'type',
      lines = {
        ": [{ url: 'https://storage.googleapis.com/muxdemofiles/mux-video-intro.mp4' }],",
        '    play',
      },
      afterLastLine = 'nothing',
    },
    { type = 'triggerCompletions' },
    { type = 'wait', waitMs = 200 },
    { type = 'selectFromAutocomplete', triggerCompletions = false },
    { type = 'wait', waitMs = 200 },
    { type = 'closeHoverBox' },
    { type = 'hoverDocumentation' },
    { type = 'wait', waitMs = 3000 },
    {
      type = 'type',
      lines = {
        ": ['",
      },
      afterLastLine = 'nothing',
    },
    { type = 'wait', waitMs = 1200 },
    { type = 'selectFromAutocomplete' },
    { type = 'wait', waitMs = 200 },
    { type = 'type', lines = { "']," } },
    {
      type = 'type',
      lines = {
        '  });',
        '  console.log(asset);',
        '',
        '  const assets = [];',
      },
      typingSpeed = 'instant',
    },
    {
      type = 'type',
      lines = {
        '  for await (const asset of mux.video.assets.list()) {',
        '    console.log(asset.id);',
        '    assets.push(asset);',
        '  }',
        '  console.log(assets.length);',
        '}',
        '',
        'main().catch(console.error);',
      },
      afterLastLine = 'nothing',
      typingSpeed = 'instant',
    },
    {
      type = 'saveFile',
    },
  }

  -- TODO:
  --
  --   macos settings
  --   ----
  --   disable preference macOS Keyboard > Insert period after double space
  --
  --   vscode settings:
  --   ---
  --   disable auto close quotes
  --   disable auto close brackets
  --   disable auto indent
  --   disable breadcrumbs
  --   disable TS validation (red errors)
  --   disable TS validation (red errors)
  --   hide minimap
  --   hide activity bar
  --   window.title == "blah-node demo"
  --
  -- Our "movie script"
  -- local dummyScript = {
  --   {
  --     type = 'type',
  --     lines = {
  --       "import EdgeImpulse from './index';",
  --       "",
  --       "const client = new EdgeImpulse({ apiKey: 'ei_yourkey' });",
  --       "",
  --       "const main = async () => {",
  --     }
  --   },
  --   {
  --     type = 'type',
  --     lines = {
  --       "  const { projects } = await client.projects.",
  --     },
  --     afterLastLine = "waitForAutocomplete",
  --   },
  --   {
  --     type = 'selectFromAutocomplete',
  --     movesBeforeSelect = { 'down' },
  --   },
  --   {
  --     type = 'type',
  --     lines = {
  --       "();",
  --       "",
  --       "  projects.forEach((project) => {",
  --       "    console.log(`- Found project ${project.",
  --     },
  --     afterLastLine = "waitForAutocomplete",
  --   },
  --   {
  --     type = 'selectFromAutocomplete',
  --     narrowResults = "id",
  --   },
  --   {
  --     type = 'type',
  --     lines = { '}, description: ${project.' },
  --     afterLastLine = "waitForAutocomplete",
  --   },
  --   {
  --     type = 'selectFromAutocomplete',
  --     narrowResults = "desc",
  --   },
  --   {
  --     type = 'type',
  --     lines = {
  --       "}`);",
  --       "  });",
  --       "};",
  --       "",
  --       "main();",
  --     },
  --     afterLastLine = "nothing",
  --   },
  -- }

  runMovieScript(dummyScript)
end)
