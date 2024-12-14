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

local function in_pay_server()
  return string.find(vim.fn.getcwd(), "pay-server", 1, true)
end

return {
  stripe = {
    machine = is_stripe_machine(),
    laptop = is_stripe_laptop(),
    payServer = in_pay_server(),
    utils = {
      is_stripe_machine = is_stripe_machine,
    }
  }
}
