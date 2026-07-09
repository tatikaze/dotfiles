#!/bin/sh
# 3ペイン開発レイアウトを現在のタブに構成する。
# 旧 wezterm の gui-startup (spawn → split 0.3 → split 0.5) と
# LEADER+i のカスタムレイアウトの後継。
#
# 構成: 左メイン | 右(上下2分割) の計3ペイン。
#   +--------+--------+
#   |        |  右上  |
#   | 左メイン+--------+
#   |        |  右下  |
#   +--------+--------+
#
# herdr の pane split は --direction right/down のみ。--current を使い
# フォーカス移動を挟んで順に分割する (pane_id の JSON パース不要)。
set -e

# 1. 左右に分割 → 右ペインへフォーカス
herdr pane split --current --direction right --ratio 0.5 --focus

# 2. 右ペインを上下に分割
herdr pane split --current --direction down --ratio 0.5 --focus

# 3. 最初の左メインペインへフォーカスを戻す
herdr pane focus --direction left
