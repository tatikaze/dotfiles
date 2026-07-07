local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Powerline風の矢印
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local PROJECT_PALETTE = {
  "#ae8b2d",
  "#2d8bae",
  "#ae2d8b",
  "#8bae2d",
  "#5d2dae",
  "#2dae5d",
  "#ae5d2d",
  "#2daea0",
}

local function project_color(name)
  local h = 0
  for i = 1, #name do
    h = (h * 31 + name:byte(i)) % #PROJECT_PALETTE
  end
  return PROJECT_PALETTE[h + 1]
end

local function tab_project_name(tab)
  local cwd_uri = tab.active_pane.current_working_dir
  if not cwd_uri then
    return tab.active_pane.title
  end
  local path = cwd_uri.file_path or tostring(cwd_uri):gsub("^file://[^/]*", "")
  path = path:gsub("/$", "")
  local base = path:match("([^/]+)$")
  return base or tab.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local is_active = tab.is_active
  local edge_bg = "#0b0022"
  local name = tab_project_name(tab)
  local bg = is_active and project_color(name) or "#1b1032"
  local fg = "#ffffff"
  local edge_fg = bg
  local label = (tab.tab_index + 1) .. ":" .. name
  local title = wezterm.truncate_right(label, max_width - 2)

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
