local resolvePath = require("utils.resolve-path")

local function getDDCCTLBinary()
  return resolvePath({
    os.getenv("HOME") .. "/.nix-profile/bin/ddcctl", -- crazy
    "/usr/local/bin/ddcctl", -- intel
    "/opt/homebrew/bin/ddcctl", -- m1
  })
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

  if hs.host.localizedName() == "pineapple" then
    -- m1 laptop
    binary = os.getenv("HOME") .. "/.local/bin/m1ddc"
    hs.execute(binary .. " display 1 set input " .. inputNumber)
  else
    binary = getDDCCTLBinary()
    hs.execute(binary .. " -d 1 -i " .. inputNumber)
  end
end

hyperKey:bind("w"):toFunction("Switch monitor input", switchMonitor)
