local function file_exists(name)
  local f = io.open(name,"r")

  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function getDDCCTLBinary()
  local binaryLocations = {
    os.getenv("HOME") .. "/.nix-profile/bin/ddcctl", -- crazy
    "/usr/local/bin/ddcctl", -- intel
    "/opt/homebrew/bin/ddcctl", -- m1
  }

  for _, path in ipairs(binaryLocations) do
    if file_exists(path) then
      return path
    end
  end

  return nil
end

local function switchMonitor()
  -- DP1 is 15
  -- USB-C is 27
  --
  -- See:
  --   https://github.com/kfix/ddcctl#input-sources
  --   https://github.com/kfix/ddcctl/issues/76
  inputNumber = 15

  if hs.host.localizedName() == "sorny" then
    inputNumber = 27
  end

  if hs.host.localizedName() == "calavera" then
    -- m1 laptop
    binary = os.getenv('HOME') .. "/.local/bin/m1ddc"
    hs.execute(binary .. " display 1 set input " .. inputNumber)
  else
    binary = getDDCCTLBinary()
    hs.execute(binary .. " -d 1 -i " .. inputNumber)
  end
end

hyperKey:bind('w'):toFunction("Switch monitor input", switchMonitor)
