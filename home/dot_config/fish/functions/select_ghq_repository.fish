function select_ghq_repository
  set ghq_path (ghq list | fzf --preview "cat --color=always --style=header,grid --line-range :80 (ghq root)/{}/README.*")
  set repo_path (ghq root)"/"$ghq_path | echo ""
  if [ -n "$repo_path" ]
    cd $repo_path
    echo "$repo_path"
    commandline -f repaint
  end
end
