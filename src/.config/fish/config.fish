set fish_theme agnoster

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


