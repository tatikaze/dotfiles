#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# automatic start tmux
if [[ ! -n $TMUX ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    #tmux new-session && exit
    ID="(NO SESSIONS)"
  fi
  create_new_session="Create New Session"
  ID="${create_new_session}\n$ID"
  ID="`echo $ID | fzf | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session && exit
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID" && exit
  else
    # Start terminal normally
  fi
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PATH=$PATH:$HOME/.go/bin

export BIN=~/.local/bin
export PATH=$BIN:$PATH # .local/binで横取りしたいアプリのためにわざと前に定義

export EDITOR=vim

fpath=(~/.zsh/completions $fpath) 
autoload -U compinit && compinit

repo() {
  local dir
  dir=$(ghq list > /dev/null | fzf --reverse +m) &&
    cd $(ghq root)/$dir
}


