#!/bin/bash

set -e

echo "🐠 Setting up Fish shell plugins..."

# Install fisher (Fish plugin manager)
if [[ ! -e "$HOME/.config/fish/functions/fisher.fish" ]]; then
    echo "Installing fisher..."
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
else
    echo "✓ fisher already installed"
fi

# Install fish plugins
echo "Installing fish plugins..."
fish -c "
    fisher install jethrokuan/z
    fisher install oh-my-fish/theme-bobthefish
    fisher install decors/fish-ghq
"

# Configure ghq
if command -v ghq &> /dev/null; then
    git config --global ghq.root ~/.ghq || true
    echo "✓ ghq configured"
fi

echo "✨ Fish shell setup complete!"
