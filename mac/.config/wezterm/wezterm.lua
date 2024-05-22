local wezterm = require("wezterm")
local act = wezterm.action
local tab_bar_style_settings = require("./tab_bar_style_settings")
local custom_bindings = require("./custom_key_bindings")

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  pane:split({ size = 0.3 })
  pane:split({ size = 0.5 })
end)

wezterm.on("open-tty-clock", function(window, pane)
  window:perform_action(pane, act.PaneDomain("CurrentPane"), act.SendString("tty-clock -s -C 3 -c -C 3 -f '%a %b %d %I:%M:%S %p'"))
end)

return {
  leader = { key = "s", mods = "CTRL" },
  keys = custom_bindings,

  key_tables = {
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape
      { key = "Escape", action = "PopKeyTable" },
    },
  },
  font_size = 10,
  color_scheme = "FishTank",
  window_background_opacity = 0.95,
  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.8,
  },
  colors = {
    split = "#666666",
  },
  tab_bar_at_bottom = true,
  tab_bar_style = tab_bar_style_settings,
  window_decorations = "RESIZE",
}
