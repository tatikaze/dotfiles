#!/bin/bash

set -e

echo "🔧 Installing Homebrew packages..."

# brew install
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Essential CLI tools
PACKAGES=(
    "fish"
    "tmux"
    "eza"
    "tig"
    "ghq"
    "bat"
    "neovim"
)

echo "Checking and installing required packages..."
for package in "${PACKAGES[@]}"; do
    if ! brew list "$package" &> /dev/null; then
        echo "  Installing $package..."
        brew install "$package"
    else
        echo "  ✓ $package already installed"
    fi
done

echo "✨ Package installation complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Install Cica font manually: https://github.com/miiton/Cica"
echo "  2. Change default shell to fish:"
echo "     - Add fish to /etc/shells: echo \"\$(which fish)\" | sudo tee -a /etc/shells"
echo "     - Change shell: chsh -s \$(which fish)"
