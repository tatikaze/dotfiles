# file
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# tmux
ln -sf $SCRIPT_DIR/.tmux.conf $HOME

# fish
ln -sf $SCRIPT_DIR/.config/fish/config.fish $HOME/.config/fish/config.fish
for file in $SCRIPT_DIR/.config/fish/functions/*; do
  ln -sf "$file" ~/.config/fish/functions/
done

# nvim
mkdir -p $HOME/.config/nvim
ln -sf $SCRIPT_DIR/.config/nvim/init.lua $HOME/.config/nvim/init.lua

# lazy-lock.json (プラグインバージョンロック)
if [ -f "$SCRIPT_DIR/.config/nvim/lazy-lock.json" ]; then
  ln -sf $SCRIPT_DIR/.config/nvim/lazy-lock.json $HOME/.config/nvim/lazy-lock.json
fi

# lua設定ファイル
mkdir -p $HOME/.config/nvim/lua
for file in $SCRIPT_DIR/.config/nvim/lua/*.lua; do
  if [ -f "$file" ]; then
    ln -sf "$file" ~/.config/nvim/lua/
  fi
done

# lua/pluginsディレクトリ全体をシンボリックリンク
# 既存のpluginsディレクトリまたはシンボリックリンクを削除
rm -rf $HOME/.config/nvim/lua/plugins
ln -sf $SCRIPT_DIR/.config/nvim/lua/plugins $HOME/.config/nvim/lua/plugins

mkdir -p $HOME/.config/wezterm
for file in $SCRIPT_DIR/.config/wezterm/*; do
  ln -sf "$file" ~/.config/wezterm/
done
