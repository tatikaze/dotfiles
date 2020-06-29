set fish_theme agnoster

# tmux の自動起動
if test -z $TMUX
  tmux new-session
end
