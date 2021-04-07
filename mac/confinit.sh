# file
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# tmux
ln -sf $SCRIPT_DIR/.tmux.conf $HOME

# vim
ln -sf $SCRIPT_DIR/.vimrc $HOME

# fish
ln -sf $SCRIPT_DIR/.config/fish/config.fish $HOME/.config/fish/config.fish
