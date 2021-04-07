# brew install
if ! command -v brew &> /dev/null; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# cica install
echo "Please install Cica font install"

echo "Please brew install list:"
# tmux install
if ! command -v tmux &> /dev/null; then
	echo "  tmux"
fi

# fish install
if command -v fish &> /dev/null; then
	if [[ ! -e "$HOME/.config/fish/functions/fisher.fish" ]] ; then
		  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
			curl -L https://get.oh-my.fish | fish
			fish omf install bobthefish
	fi
else
	echo "  fish"
	echo "    1. add '"$(which fish)"' > sudo vim /etc/shells"
	echo "    2. run 'chsh -s $(which fish)'"
fi

# exa install
if ! command -v exa &> /dev/null; then
	echo "  exa"
fi

sh ./confinit.sh