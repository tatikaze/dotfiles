local wezterm = require("wezterm")

-- wezterm はレンダリング層に専念する。
-- ワークスペース/タブ/ペイン/セッションとキーバインドは herdr が担当する
-- (~/.config/herdr/config.toml)。起動時に herdr へ自動 attach する。

local config = {
  -- 起動でそのまま herdr の永続セッションへ attach / 生成する。
  default_prog = { "herdr" },

  -- 最下部の情報バーは ai_status.lua で設定する。

  font_size = 10,
  color_scheme = "FishTank",
  window_background_opacity = 0.7,
  macos_window_background_blur = 50,
  window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
  },
  window_decorations = "RESIZE",
}

require("ai_status").apply(config)
return config
