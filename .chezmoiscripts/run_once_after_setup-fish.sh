#!/bin/bash

set -e

echo "🐠 Setting up Fish shell plugins..."

# fisher を最新版(v4+)に揃える
# 既存がv3でも上書きする。v4インストーラは既存ファイルとのコンフリクトを
# 検出して停止するため、事前にv3のファイルを掃除する
# (git.io/fisher は廃止済みなので raw.githubusercontent.com を直叩き)
rm -f "$HOME/.config/fish/functions/fisher.fish" "$HOME/.config/fish/completions/fisher.fish"
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# プラグインインストール (fisher v4 は `install`)
echo "Installing fish plugins..."
fish -c "fisher install jethrokuan/z oh-my-fish/theme-bobthefish decors/fish-ghq"

# ghq設定
if command -v ghq &> /dev/null; then
    git config --global ghq.root ~/.ghq || true
    echo "✓ ghq configured"
fi

echo "✨ Fish shell setup complete!"
