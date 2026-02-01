# WSL2環境ではルートディレクトリがwindows側になってしまう
cd

# golang
set -x PATH /usr/local/bin $PATH
set -x GOPATH $HOME/.go
set -x PATH $PATH $GOPATH/bin

# rust
set -x CARGOPATH $HOME/.cargo
set -x PATH $PATH $CARGOPATH/bin

# npm
set -x NPMPATH $HOME/.npm-global
set -x PATH $PATH $NPMPATH/bin

# tmux の自動起動
if test -z $TMUX
  tmux new-session
end

alias cat='batcat'
alias ls='exa --git -I "node_modules"'

alias stu='git status'
alias add='git add'
alias commit='git commit'
alias branch='git branch'
alias push='git push'

# ghq内部のリポジトリをfzfで選択、移動
function select_ghq_repository
	set ghq_path (ghq list | fzf --preview "cat --color=always --style=header,grid --line-range :80 (ghq root)/{}/README.*")
	set repo_path (ghq root)"/"$ghq_path | echo ""
	cd $repo_path
	commandline -f repaint
end

function exa_flex_tree
	ls -l --tree --level=$argv
end

bind \cg 'select_ghq_repository'
alias tre='exa_flex_tree'

export LSCOLORS=Gxfxcxdxbxegedabagacad
