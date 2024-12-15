local ApplicationBinding = {}

function ApplicationBinding:new(applicationPath)
  -- Convert an `applicationPath` like "/Applications/Google Chrome.app"
  -- into just its name: "Google Chrome"
  local parts = hs.fnutils.split(applicationPath, "/")
  local name = parts[#parts]

  local nameParts = hs.fnutils.split(name, ".", nil, true)
  local basename = nameParts[1]

  local applicationBinding = {
    name = basename,
    applicationPath = applicationPath,
  }

  setmetatable(applicationBinding, self)
  self.__index = self

  return applicationBinding
end

function ApplicationBinding:launch()
  hs.application.launchOrFocus(self.applicationPath)
end

------

local FunctionBinding = {}

function FunctionBinding:new(name, fn)
  local functionBinding = {
    name = name,
    fn = fn,
  }

  setmetatable(functionBinding, self)
  self.__index = self

  return functionBinding
end

function FunctionBinding:launch()
  self.fn()
end

------

return {
  ApplicationBinding = ApplicationBinding,
  FunctionBinding = FunctionBinding,
}
