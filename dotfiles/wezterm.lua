-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true
config.audible_bell = "Disabled"

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback({
  -- Main font
  "JetBrainsMono NFM",
  "Noto Sans",
})
config.front_end = "WebGpu" -- https://github.com/wezterm/wezterm/issues/6005
config.harfbuzz_features = { "calt = 0", "clig = 0", "liga = 0" }

-- and finally, return the configuration to wezterm
return config
