## WSL2環境ではルートディレクトリがwindows側になってしまう
#cd
#
## golang
set -x PATH /usr/local/bin $PATH
#set -x GOPATH $HOME/.go
#set -x PATH $PATH $GOPATH/bin
#
## rust
#set -x CARGOPATH $HOME/.cargo
#set -x PATH $PATH $CARGOPATH/bin
#

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

#
set -x HOMEBREW /opt/homebrew
set -x PATH $PATH $HOMEBREW/bin

# tmux の自動起動
if test -z $TMUX
  tmux new-session
end

alias cat='bat'
alias ls='exa --git'
alias lsa='exa --git'
alias lc='clear && pwd && ls'
alias updir='cd .. && ls'

alias stu='git status'
alias add='git add'
alias commit='git commit'
alias branch='git branch'
alias push='git push'

alias doco='docker compose'

#ghq内部のリポジトリをfzfで選択、移動
function select_ghq_repository
	set ghq_path (ghq list | fzf --preview "cat --color=always --style=header,grid --line-range :80 (ghq root)/{}/README.*")
	set repo_path (ghq root)"/"$ghq_path | echo ""
	if [ -n "$repo_path" ]
		cd $repo_path
		echo "$repo_path"
		commandline -f repaint
	end
end

function exa_flex_tree
	ls -l --tree --level=$argv
end

# package.jsonのいる階層まで登る
function cd_project_root
	##	while ! [ -d .git || test $PWD = $HOME ]
	while ! test -d .git -o $PWD = $HOME
			cd ..
	end
end

function fim
	set fzf_path (fzf)
	if [ -n $fzf_path ] 
		vim $fzf_path
	end
end

bind \cg 'select_ghq_repository'
alias tre='exa_flex_tree'
alias pjr='cd_project_root'
alias vim='nvim'


#export LSCOLORS=Gxfxcxdxbxegedabagacad

fish_add_path /opt/homebrew/opt/mysql-client@5.7/bin

# pnpm
set -gx PNPM_HOME "/Users/tatikaze/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
