## WSL2環境ではルートディレクトリがwindows側になってしまう
#cd

## golang
set -x PATH /usr/local/bin $PATH
#set -x GOPATH $HOME/.go
#set -x PATH $PATH $GOPATH/bin

## rust
set -x CARGOPATH $HOME/.cargo/bin
set -x PATH $PATH $CARGOPATH

## npm
#set -x NPMPATH $HOME/.npm-global
#set -x PATH $PATH $NPMPATH/bin
set -x PATH $PATH /opt/homebrew/bin

## yarn
set -x PATH $PATH (yarn global bin)
#
## Unmanaged Commands
set -x CLIS ~/.cli

## Android
set -x PATH $PATH ~/Library/Android/sdk/platform-tools

### Flutter
set -x PATH $PATH $CLIS/flutter/bin

### Flutter DevTool
set -x PATH $PATH $CLI/flutter/.pub-cache/bin

### Custom Command
set -x CCOMMAND_PATH $HOME/Projects/custom-command
set -x PATH $PATH $CCOMMAND_PATH

#
set -x HOMEBREW /opt/homebrew
set -x PATH $PATH $HOMEBREW/bin

alias cat='bat'
alias ls='exa --git'
alias lsa='exa --git'
alias lc='clear && pwd && ls'

alias doco='docker compose'

function exa_flex_tree
	ls -l --tree --level=$argv
end

alias tre='exa_flex_tree'
alias pjr='cd_project_root'
alias pkr='cd_package_root'
alias vim='nvim'

fish_add_path /opt/homebrew/opt/mysql-client@5.7/bin

# pnpm
set -gx PNPM_HOME "/Users/tatikaze/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

# wezterm
# set -gx WEZTERM_CONFIG /Users/tatikaze/.config/wezterm/wezterm.lua
# set -gx PATH $PATH $WEZTERM_CONFIG
# set -gx WEZTERM_BINARY /Applications/WezTerm.app/Contents/MacOS
# set -gx PATH $PATH $WEZTERM_BINARY
# wezterm end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
