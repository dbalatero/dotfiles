-- Helper function to convert RGBA values to floating point numbers
-- that hs.canvas can use.
local function rgba(r, g, b, a)
  a = a or 1.0

  return {
    red = r / 255,
    green = g / 255,
    blue = b / 255,
    alpha = a,
  }
end

local function buildCanvas(bindings)
  -- How much padding should there be around the edges of the container so it
  -- looks nice?
  local containerPadding = 25

  -- How many hints should we have per column?
  local itemsPerColumn = 6

  -- How tall is each hi;nt?
  local itemHeight = 25

  -- How much margin should we have between hints within a column?
  local itemBottomMargin = 10

  -- The total height of the container = height + bottom margin.
  local itemContainerHeight = itemHeight + itemBottomMargin

  -- How wide each column should be
  local columnWidth = 275

  -- How many total columns do we have?
  --
  --   Example: if there's 25 key bindings and 6 items per column, we'd have:
  --
  --     25 / 6 = 4.166666667 columns
  --
  --   which we'd ceil() round up to 5.
  local columnCount = math.ceil(#bindings / itemsPerColumn)

  -- The full width of the canvas is calculated by adding together:
  --
  --   * The left and right padding (`containerPadding * 2`)
  --   * Enough width for the number of columns we have (`columnCount * columnWidth`)
  --
  local canvasWidth = (containerPadding * 2) + (columnCount * columnWidth)

  -- The full height of the canvas is calculated by adding together:
  --
  --  * The top and bottom padding (`containerPadding * 2`)
  --  * Enough height to contain a single column's hints (`itemsPerColumn * itemContainerHeight`)
  --
  -- Because the final item in the column will add some extra margin, we subtract
  -- `itemBottomMargin` from the total so the top and bottom appear balanced.
  local canvasHeight = (containerPadding * 2)
    + (itemsPerColumn * itemContainerHeight)
    - itemBottomMargin

  local canvas = hs.canvas.new({
    w = canvasWidth,
    h = canvasHeight,
    x = 100,
    y = 100,
  })

  -- Position the canvas in the very center of the screen.
  local frame = hs.screen.mainScreen():frame()

  canvas:topLeft({
    x = (frame.w / 2) - (canvasWidth / 2),
    y = (frame.h / 2) - (canvasHeight / 2),
  })

  -- Make sure it sits above all the windows
  canvas:level("overlay")

  -- render the blue background
  canvas:insertElement({
    type = "rectangle",
    action = "fill",
    roundedRectRadii = { xRadius = 10, yRadius = 10 },
    fillColor = rgba(24, 135, 250, 1),
    frame = { x = 0, y = 0, h = "100%", w = "100%" },
  })

  -- Sort the keybindings by key code, from A-Z
  table.sort(bindings, function(a, b)
    return a.key < b.key
  end)

  -- Loop through each keybinding hint and draw it in the canvas:
  for index, entry in pairs(bindings) do
    -- How big should the square key "icon" be? 25x25px
    local keySize = 25

    -- How much margin should there be between the key icon and the description
    -- text?
    local keyRightMargin = 10

    -- Lua's tables are 1-indexed, but the math is going to be wayyy easier if
    -- we convert to 0-indexed before computing the `(x, y)` coordinate of this
    -- hint.
    local zeroIndex = index - 1

    -- Figure out which # column this hint belongs in. Starts at 0.
    local columnIndex = math.floor(zeroIndex / itemsPerColumn)

    -- Figure out which row this hint belongs in. Starts at 0.
    local rowIndex = zeroIndex % itemsPerColumn

    -- Find the upper left starting coordinate of each hint `(x, y)`:

    -- Starting from 0, we get the `x` coordinate by moving to the right by
    -- `containerPadding`, then moving right however many column widths we need:
    local startX = containerPadding + (columnIndex * columnWidth)

    -- Starting from 0, we get the `y` coordinate by moving down by
    -- `containerPadding`, then moving down by however many `itemContainerHeight`
    local startY = containerPadding + (rowIndex * itemContainerHeight)

    -- Draw a 25x25 square keycap "icon"
    canvas:insertElement({
      type = "rectangle",
      action = "fill",
      roundedRectRadii = { xRadius = 5, yRadius = 5 },
      fillColor = rgba(255, 255, 255, 1.0),
      frame = {
        x = startX,
        y = startY,
        w = keySize,
        h = keySize,
      },
      -- Add a nice drop shadow to it.
      withShadow = true,
      shadow = {
        blurRadius = 5.0,
        color = { alpha = 1 / 3 },
        offset = { h = -2.0, w = 2.0 },
      },
    })

    -- Write the keycode (e.g. "Z") inside of the 25x25 keycap icon.
    canvas:insertElement({
      type = "text",
      -- Uppercase keys look nicer.
      text = string.upper(entry.key),
      action = "fill",
      frame = {
        x = startX,
        y = startY + 3,
        h = keySize,
        w = keySize,
      },
      -- Center the text in the keycap
      textAlignment = "center",
      textColor = rgba(38, 38, 38, 1.0),
      textFont = "Helvetica Bold",
      textSize = 14,
    })

    -- Write the description (e.g. "Mute Zoom") to the right of the keycap
    canvas:insertElement({
      type = "text",
      text = hs.styledtext.new(entry.binding.name, {
        font = { name = "Helvetica Neue", size = 16 },
        color = rgba(255, 255, 255, 1.0),
        kerning = 1.2,
        shadow = {
          blurRadius = 10,
        },
      }),
      action = "fill",
      frame = {
        -- Make sure there's margin between the keycap at the text so it
        -- doesn't look cramped.
        x = startX + keySize + keyRightMargin,
        y = startY,
        h = keySize,
        w = 300,
      },
    })
  end

  return canvas
end

return buildCanvas
