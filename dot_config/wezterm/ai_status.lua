local wezterm = require('wezterm')
local M = {}
local cache = wezterm.home_dir .. '/.cache/wezterm-ai-status/display.json'
local collector = wezterm.config_dir .. '/ai_status.py'
local last_spawn = 0

local function read_state()
  local file = io.open(cache, 'r')
  if not file then return {} end
  local text = file:read('*a')
  file:close()
  local ok, value = pcall(wezterm.json_parse, text)
  if ok and type(value) == 'table' then return value end
  return {}
end

local function clip(text, width)
  if wezterm.column_width(text) <= width then return text end
  return wezterm.truncate_right(text, math.max(0, width - 3)) .. '...'
end

function M.apply(config)
  -- herdr continues to own tabs/panes; this row contains status text only.
  config.enable_tab_bar = true
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = false
  config.use_fancy_tab_bar = false
  config.show_tabs_in_tab_bar = false
  config.show_new_tab_button_in_tab_bar = false
  config.status_update_interval = 2000

  wezterm.on('update-status', function(window, pane)
    local now = os.time()
    if now - last_spawn >= 15 then
      last_spawn = now
      pcall(wezterm.background_child_process, {'/usr/bin/python3', collector, 'collect'})
    end
    local state = read_state()
    local claude = state.claude or {full = 'Claude: waiting for statusline', compact = 'Claude: waiting'}
    local codex = state.codex or {full = 'Codex: loading usage', compact = 'Codex: loading'}
    local width = math.max(20, pane:get_dimensions().cols - 4)
    local left, right = claude.full, codex.full
    if wezterm.column_width(left) + wezterm.column_width(right) + 3 > width then
      left, right = claude.compact, codex.compact
    end
    local stale = state.updated and now - state.updated > 180
    if stale then left = 'STALE ' .. left; right = 'STALE ' .. right end
    if wezterm.column_width(left) + wezterm.column_width(right) + 3 > width then
      local budget = math.floor((width - 3) / 2)
      local left_budget = math.min(wezterm.column_width(left), budget)
      local right_budget = math.min(wezterm.column_width(right), width - 3 - left_budget)
      left_budget = width - 3 - right_budget
      left, right = clip(left, left_budget), clip(right, right_budget)
    end
    window:set_right_status(wezterm.format({
      {Background = {Color = '#16212b'}},
      {Foreground = {Color = '#e8b88e'}}, {Text = ' ' .. left},
      {Foreground = {Color = '#788995'}}, {Text = ' | '},
      {Foreground = {Color = '#83d8c7'}}, {Text = right .. ' '},
    }))
    window:set_left_status('')
  end)
end

return M
