#! /bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)

# applications

# zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

ln -sf $SCRIPT_DIR/src/.zlogin $HOME
ln -sf $SCRIPT_DIR/src/.zlogout $HOME
ln -sf $SCRIPT_DIR/src/.zpreztorc $HOME
ln -sf $SCRIPT_DIR/src/.zprofile $HOME
ln -sf $SCRIPT_DIR/src/.zshenv $HOME
ln -sf $SCRIPT_DIR/src/.zshrc $HOME

# tmux
ln -sf $SCRIPT_DIR/src/.tmux.conf $HOME
