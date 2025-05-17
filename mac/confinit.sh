# file
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# tmux
ln -sf $SCRIPT_DIR/.tmux.conf $HOME

# fish
ln -sf $SCRIPT_DIR/.config/fish/config.fish $HOME/.config/fish/config.fish

# nvim
ln -sf $SCRIPT_DIR/.config/nvim/init.lua $HOME/.config/nvim/init.lua

mkdir -p $HOME/.config/nvim/lua
for file in $SCRIPT_DIR/.config/nvim/lua/*; do
  ln -sf "$file" ~/.config/nvim/lua/
done

mkdir -p $HOME/.config/nvim/plugin
for file in $SCRIPT_DIR/.config/nvim/plugin/*; do
  ln -sf "$file" ~/.config/nvim/plugin/
done

mkdir -p $HOME/.config/wezterm
for file in $SCRIPT_DIR/.config/wezterm/*; do
  ln -sf "$file" ~/.config/wezterm/
done
