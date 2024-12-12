ReadLater = {}

ReadLater.articles = {}

ReadLater.menu = hs.menubar.new()
ReadLater.menu:setIcon(hs.image.imageFromPath(os.getenv('HOME') .. '/.hammerspoon/read-later/book.png'))

local saveCurrentTabArticle = nil
local updateMenu = nil

--------- sync functions

-- Where do you want to persist your articles to disk?
--
-- If you use Dropbox and save it to your ~/Dropbox folder, it will work across
-- multiple computers. Otherwise, you can choose a different path.
ReadLater.jsonSyncPath = os.getenv('HOME') .. '/Dropbox/read-later.json'

local function readArticlesFromDisk()
  local file = io.open(ReadLater.jsonSyncPath, 'r')

  if file then
    local contents = file:read('*all')
    file:close()

    ReadLater.articles = hs.json.decode(contents) or {}
    updateMenu()
  end
end

local function writeArticlesToDisk()
  hs.json.write(ReadLater.articles, ReadLater.jsonSyncPath, true, true)
end

--- read/remove functions

local function openUrl(url)
  local task = hs.task.new(
    '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    nil,
    function() end, -- noop
    {
      url,
    }
  )

  task:start()
end

local function removeArticle(article)
  ReadLater.articles = hs.fnutils.filter(ReadLater.articles, function(savedArticle)
    return savedArticle.url ~= article.url
  end)

  updateMenu()
  writeArticlesToDisk()
end

local function readArticle(article)
  openUrl(article.url)
  removeArticle(article)
end

local function readRandomArticle()
  local index = math.random(1, #ReadLater.articles)
  readArticle(ReadLater.articles[index])
end

--- menu code

updateMenu = function()
  local items = {
    {
      title = 'ReadLater',
      disabled = true,
    },
  }

  -- Add a divider line
  table.insert(items, { title = '-' })

  -- Render each article
  if #ReadLater.articles == 0 then
    table.insert(items, {
      title = 'No more articles to read',
      disabled = true,
    })
  else
    for _, article in ipairs(ReadLater.articles) do
      -- Add each article to the list of menu items
      table.insert(items, {
        title = article.title,
        fn = function()
          readArticle(article)
        end,
        menu = {
          {
            title = 'Remove article',
            fn = function()
              removeArticle(article)
            end,
          },
        },
      })
    end
  end

  table.insert(items, { title = '-' })
  table.insert(items, {
    title = 'Save current tab          (⌘⌥⌃ S)',
    fn = saveCurrentTabArticle,
  })

  table.insert(items, {
    title = 'Read random article',
    fn = readRandomArticle,
  })

  ReadLater.menu:setTitle('(' .. tostring(#ReadLater.articles) .. ')')
  ReadLater.menu:setMenu(items)
end

-- Get the URL and <title> of the current Chrome tab, and return it as
--
--   {
--     url = "https://...",
--     title = "An interesting article",
--   }
--
-- Returns `nil` if there are no open Chrome tabs.
local function getCurrentArticle()
  if not hs.application.find('Google Chrome') then
    -- Chrome isn't running right now.
    return nil
  end

  -- Get the URL of the current tab
  local _, url = hs.osascript.applescript([[
      tell application "Google Chrome"
        get URL of active tab of first window
      end tell
    ]])

  -- Get the <title> of the current tab.
  local _, title = hs.osascript.applescript([[
      tell application "Google Chrome"
        get title of active tab of first window
      end tell
    ]])

  -- Remove trailing garbage from window title
  title = string.gsub(title, '- - Google Chrome.*', '')

  return {
    url = url,
    title = title,
  }
end

saveCurrentTabArticle = function()
  article = getCurrentArticle()

  if not article then
    return
  end

  -- Save the article
  table.insert(ReadLater.articles, article)

  -- Refresh the menubar since we have a new article
  updateMenu()

  -- Sync to disk
  writeArticlesToDisk()

  hs.alert('Saved ' .. article.title)
end

superKey:bind('s'):toFunction('Read later', saveCurrentTabArticle)

----

updateMenu()
readArticlesFromDisk()

jsonWatcher = hs.pathwatcher.new(ReadLater.jsonSyncPath, function(paths, flags)
  if hs.fnutils.contains(paths, ReadLater.jsonSyncPath) then
    readArticlesFromDisk()
  end
end)

jsonWatcher:start()
