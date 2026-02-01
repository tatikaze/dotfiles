# package.jsonのいる階層まで登る
function cd_project_root
  ##  while ! [ -d .git || test $PWD = $HOME ]
  while ! test -d .git -o $PWD = $HOME
      cd ..
  end
end

alias pjr='cd_project_root'
