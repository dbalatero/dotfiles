local function is_macos()
  -- Get the operating system name
  local os_name = vim.loop.os_uname().sysname

  -- Check if it's Darwin, which indicates macOS
  return os_name == "Darwin"
end

local function is_stripe_laptop()
  return is_macos() and vim.fn.isdirectory(os.getenv("HOME") .. "/stripe/pay-server") == 1
end

local function is_stripe_machine()
  return is_stripe_laptop()
end

return {
  stripe = {
    machine = is_stripe_machine(),
    laptop = is_stripe_laptop(),
  }
}
