local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Powerline風の矢印
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local is_active = tab.is_active
  local edge_bg = "#0b0022"
  local bg = is_active and "#ae8b2d" or "#1b1032"
  local fg = "#ffffff"
  local edge_fg = bg
  local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)

  return {
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = " " .. title .. " " },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

return config
