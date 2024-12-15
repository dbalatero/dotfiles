-- brew install tesseract
local function pasteOcrText()
  local image = hs.pasteboard.readImage()

  if image then
    local imagePath = "/tmp/ocr_image.png"
    image:saveToFile(imagePath)

    local _, success = hs.execute(
      "/usr/local/bin/tesseract -l eng " .. imagePath .. " /tmp/ocr_output"
    )

    if success then
      -- Read in OCR result
      local file = io.open("/tmp/ocr_output.txt", "r")
      local content = file:read("*all")
      file:close()

      -- Type out the OCR
      hs.eventtap.keyStrokes(content)

      -- clean up
      hs.execute("rm " .. imagePath .. " /tmp/ocr_output.txt")
    end
  end
end

superKey:bind("p"):toFunction("Paste clipboard OCR", pasteOcrText)
