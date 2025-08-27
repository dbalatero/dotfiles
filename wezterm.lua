-- cp this to /mnt/c/Users/<user>/.wezterm.lua

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.audible_bell = "Disabled"
config.color_scheme = wezterm.gui.get_appearance() == "Dark"
    and "Catppuccin Mocha"
  or "Catppuccin Latte"

config.hide_tab_bar_if_only_one_tab = true

config.wsl_domains = {
  {
    name = "WSL:Arch",
    distribution = "archlinux",
    default_cwd = "/home/dbalatero",
  },
}

config.default_domain = "WSL:Arch"

return config
