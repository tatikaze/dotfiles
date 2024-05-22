local wezterm = require("wezterm")

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

return {
  active_tab_left = wezterm.format({
    { Background = { Color = "#0b0022" } },
    { Foreground = { Color = "#2b2042" } },
    { Text = SOLID_LEFT_ARROW },
  }),
  active_tab_right = wezterm.format({
    { Background = { Color = "#0b0022" } },
    { Foreground = { Color = "#2b2042" } },
    { Text = SOLID_RIGHT_ARROW },
  }),
  inactive_tab_left = wezterm.format({
    { Background = { Color = "#0b0022" } },
    { Foreground = { Color = "#1b1032" } },
    { Text = SOLID_LEFT_ARROW },
  }),
  inactive_tab_right = wezterm.format({
    { Background = { Color = "#0b0022" } },
    { Foreground = { Color = "#1b1032" } },
    { Text = SOLID_RIGHT_ARROW },
  }),
}
