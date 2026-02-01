function fim
  if [ -z "$argv" ];
    set argv '';
  end

  set fzf_path (fzf -q $argv --preview "bat --color=always --style=header,grid,numbers --line-range :80 {}")

  if [ -n "$fzf_path" ]
    set escaped_path (string escape -- $fzf_path)
    set command "vim $escaped_path"
    echo "$command" && fish -c "$command"
  end
end
