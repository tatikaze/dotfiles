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

# lua/pluginsディレクトリ（個別プラグイン設定）
mkdir -p $HOME/.config/nvim/lua/plugins
for file in $SCRIPT_DIR/.config/nvim/lua/plugins/*; do
  if [ -f "$file" ]; then
    ln -sf "$file" ~/.config/nvim/lua/plugins/
  fi
done

mkdir -p $HOME/.config/wezterm
for file in $SCRIPT_DIR/.config/wezterm/*; do
  ln -sf "$file" ~/.config/wezterm/
done
