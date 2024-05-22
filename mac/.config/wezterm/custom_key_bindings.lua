local wezterm = require("wezterm")
local act = wezterm.action

return {
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
      timeout_milliseconds = 500,
    }),
  },
  {
    key = "i",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local tab = pane:tab()
      pane:split({ size = 0.3, direction = "Left" })
      pane:split({ size = 0.5, direction = "Right" })
      local tab = pane:tab()
      tab:activate()
      local panes_info = tab:panes_with_info()
      for _, p in ipairs(panes_info) do
        wezterm:log_info(p.index)
        if p.pane_id == 1 then
          local target_pane = p.pane
          wezterm:log_info("active" .. p.pane_idindex)
          target_pane:activate()
        end
      end
      pane:split({ size = 0.5, direction = "Bottom" })
      pane:split({ size = 0.5, direction = "Bottom" })
    end),
  },

  {
    key = "h",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "j",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "-",
    mods = "LEADER",
    action = act.SplitVertical,
  },
  {
    key = "|",
    mods = "LEADER",
    action = act.SplitHorizontal,
  },
  {
    key = "c",
    mods = "LEADER",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "p",
    mods = "LEADER",
    action = act.ActivateTabRelative(-1),
  },
  {
    key = "n",
    mods = "LEADER",
    action = act.ActivateTabRelative(1),
  },
  {
    key = "t",
    mods = "LEADER",
    action = act({ SendString = "tty-clock -c -C 3\x0D" }),
  },
}
