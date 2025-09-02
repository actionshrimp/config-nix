-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true
config.audible_bell = "Disabled"

config.unix_domains = {
  {
    name = "unix",
  },
}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.font = wezterm.font_with_fallback({
  -- Main font
  "JetBrainsMono NFM",
  "Noto Sans",
})
-- config.front_end = "WebGpu" -- https://github.com/wezterm/wezterm/issues/6005
config.harfbuzz_features = { "calt = 0", "clig = 0", "liga = 0" }

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(key)
  return {
    key = key,
    mods = "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = "CTRL" },
        }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
      end
    end),
  }
end

-- Leader is the same as my old tmux prefix
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  {
    mods = "LEADER",
    key = "s",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    mods = "LEADER",
    key = "v",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    mods = "LEADER",
    key = "c",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    mods = "LEADER",
    key = "n",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    mods = "LEADER",
    key = "p",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    mods = "LEADER",
    key = "[",
    action = wezterm.action.ActivateCopyMode,
  },
  {
    mods = "LEADER",
    key = "Space",
    action = wezterm.action.QuickSelect,
  },
  {
    mods = "LEADER",
    key = "d",
    action = wezterm.action.DetachDomain("CurrentPaneDomain"),
  },
  {
    mods = "LEADER",
    key = "b",
    action = wezterm.action.ActivateLastTab,
  },
  {
    mods = "LEADER|CTRL",
    key = "b",
    action = wezterm.action.ActivateLastTab,
  },
  {
    mods = "LEADER",
    key = "a",
    action = wezterm.action.ShowLauncher,
  },
  {
    mods = "LEADER",
    key = "h",
    action = wezterm.action.AdjustPaneSize({ "Left", 10 }),
  },
  {
    mods = "LEADER",
    key = "l",
    action = wezterm.action.AdjustPaneSize({ "Right", 10 }),
  },
  {
    mods = "LEADER",
    key = "j",
    action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
  },
  {
    mods = "LEADER",
    key = "k",
    action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
  },
  {
    mods = "LEADER",
    key = "/",
    action = wezterm.action.Search({ Regex = "" }),
  },
  {
    mods = "LEADER",
    key = "z",
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = "Q",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },

  -- move between split panes
  split_nav("h"),
  split_nav("j"),
  split_nav("k"),
  split_nav("l"),
}

for i = 0, 9 do
  table.insert(config.keys, {
    mods = "LEADER",
    key = tostring(i),
    action = wezterm.action.ActivateTab(i - 1),
  })
end

-- and finally, return the configuration to wezterm
return config
