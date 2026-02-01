# chezmoi 使用例

実際のdotfilesでクロスプラットフォーム対応を実装した例を紹介します。

## 📋 目次

1. [Fish Shell設定（テンプレート版）](#fish-shell設定)
2. [インストールスクリプト（OS別）](#インストールスクリプト)
3. [Git設定（OS別認証）](#git設定)
4. [.chezmoiignoreでの除外](#chezmoiignoreでの除外)
5. [実際の使い方](#実際の使い方)

---

## Fish Shell設定

`home/dot_config/fish/config.fish.tmpl`

### 主な特徴

- ✅ macOS、Linux、Windowsで異なるパス設定を自動切り替え
- ✅ Homebrewのパスを各OSに合わせて設定
- ✅ クリップボードコマンド（pbcopy/pbpaste）をOS別にエイリアス
- ✅ pnpmの配置場所をOSごとに対応

### テンプレート構造

```fish
{{- if eq .chezmoi.os "darwin" }}
## macOS専用設定
set -x HOMEBREW /opt/homebrew
alias pbcopy='pbcopy'

{{- else if eq .chezmoi.os "linux" }}
## Linux専用設定
set -x HOMEBREW /home/linuxbrew/.linuxbrew
alias pbcopy='xclip -selection clipboard'

{{- else if eq .chezmoi.os "windows" }}
## Windows専用設定
alias pbcopy='clip.exe'
{{- end }}

## 共通設定（全OS）
alias vim='nvim'
```

### 実際の出力（macOS）

chezmoiが生成する実際のファイル：

```fish
## macOS専用設定
set -x HOMEBREW /opt/homebrew
alias pbcopy='pbcopy'

## 共通設定（全OS）
alias vim='nvim'
```

### 実際の出力（Linux）

```fish
## Linux専用設定
set -x HOMEBREW /home/linuxbrew/.linuxbrew
alias pbcopy='xclip -selection clipboard'

## 共通設定（全OS）
alias vim='nvim'
```

---

## インストールスクリプト

`home/.chezmoiscripts/run_once_before_install-packages.sh.tmpl`

### 主な特徴

- ✅ macOS: Homebrewでインストール
- ✅ Linux: apt/dnf/pacman/zypperを自動検出
- ✅ Windows: Scoopでインストール
- ✅ Apple Silicon（arm64）対応

### コード例

```bash
{{- if eq .chezmoi.os "darwin" }}
## macOS: Homebrew
brew install fish tmux neovim eza bat

{{- else if eq .chezmoi.os "linux" }}
## Linux: パッケージマネージャー自動検出
if command -v apt &> /dev/null; then
    sudo apt install -y fish tmux neovim bat
elif command -v pacman &> /dev/null; then
    sudo pacman -S fish tmux neovim bat
fi

{{- else if eq .chezmoi.os "windows" }}
## Windows: Scoop
scoop install fish neovim bat
{{- end }}
```

### Apple Silicon対応

```bash
{{- if eq .chezmoi.os "darwin" }}
if [ "{{ .chezmoi.arch }}" = "arm64" ]; then
    # M1/M2/M3 Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi
{{- end }}
```

---

## Git設定

`home/dot_gitconfig.tmpl`

### OS別認証ヘルパー

```ini
[user]
    name = {{ .name }}
    email = {{ .email }}

[core]
{{- if eq .chezmoi.os "darwin" }}
    helper = osxkeychain
{{- else if eq .chezmoi.os "linux" }}
    helper = /usr/share/git/credential/libsecret/git-credential-libsecret
{{- else if eq .chezmoi.os "windows" }}
    helper = manager-core
    autocrlf = true
{{- end }}
```

### 仕事用/個人用の切り替え

```ini
{{- if .work }}
# 仕事用マシン
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
{{- end }}
```

設定方法（`~/.config/chezmoi/chezmoi.toml`）：

```toml
[data]
    name = "Your Name"
    email = "personal@example.com"
    work = true
    work_email = "work@company.com"
```

---

## .chezmoiignoreでの除外

`home/.chezmoiignore`

### OS別除外設定

```
{{- if ne .chezmoi.os "darwin" }}
# macOS以外でmacOS専用ディレクトリを無視
Library/
.Brewfile
{{- end }}

{{- if ne .chezmoi.os "linux" }}
# Linux以外でLinux専用設定を無視
.config/systemd/
{{- end }}

{{- if ne .chezmoi.os "windows" }}
# Windows以外でWindows専用設定を無視
AppData/
{{- end }}
```

---

## 実際の使い方

### 1. 初回セットアップ

#### macOSでの初回セットアップ

```bash
# chezmoiインストール
brew install chezmoi

# dotfilesを適用
chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git

# 設定
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<EOF
[data]
    email = "you@example.com"
    name = "Your Name"
EOF

# 再適用
chezmoi apply
```

実行結果：
```
🔧 Installing packages for darwin...
✓ fish already installed
✓ tmux already installed
  Installing neovim...
✨ Package installation complete!
```

#### Linuxでの初回セットアップ

```bash
# chezmoiインストール
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_USERNAME/dotfiles

# 設定
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<EOF
[data]
    email = "you@example.com"
    name = "Your Name"
EOF

# 再適用
chezmoi apply
```

実行結果：
```
🔧 Installing packages for linux...
Detected package manager: apt
Installing Linux packages...
✨ Package installation complete!
```

### 2. 設定ファイルの編集

```bash
# 編集（chezmoiエディタ）
chezmoi edit ~/.config/fish/config.fish

# または直接編集
vim ~/.config/fish/config.fish
chezmoi add ~/.config/fish/config.fish

# 差分確認
chezmoi diff

# 適用
chezmoi apply
```

### 3. テンプレートの確認

```bash
# テンプレート変数を確認
chezmoi data

# 出力例（macOS）:
# {
#   "chezmoi": {
#     "os": "darwin",
#     "arch": "arm64",
#     "hostname": "MacBook-Pro"
#   },
#   "email": "you@example.com",
#   "name": "Your Name"
# }
```

### 4. OS別の出力を確認

```bash
# 実際に生成されるファイルを確認（dry-run）
chezmoi cat ~/.config/fish/config.fish

# macOSでの出力:
# set -x HOMEBREW /opt/homebrew
# alias pbcopy='pbcopy'

# Linuxでの出力:
# set -x HOMEBREW /home/linuxbrew/.linuxbrew
# alias pbcopy='xclip -selection clipboard'
```

### 5. 複数マシンでの同期

#### マシンA（macOS）で編集

```bash
chezmoi edit ~/.config/fish/config.fish
# 変更を保存

chezmoi cd
git add .
git commit -m "Update fish config"
git push
```

#### マシンB（Linux）で同期

```bash
chezmoi update

# または手動で
chezmoi cd
git pull
exit
chezmoi apply
```

結果：
- macOS固有の設定はLinuxに適用されない
- Linux固有の設定が自動生成される
- 共通設定は両方に適用される

---

## 🎯 実践的なTips

### Tip 1: マシン固有設定の追加

`~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    email = "you@example.com"
    name = "Your Name"

    # カスタム変数
    work = true
    high_dpi = true
```

テンプレートで使用：

```fish
{{- if .work }}
set -x COMPANY_VPN_CONFIG ~/.vpn/work.conf
{{- end }}

{{- if .high_dpi }}
set -x GDK_SCALE 2
{{- end }}
```

### Tip 2: ホスト名での分岐

```bash
{{- if eq .chezmoi.hostname "work-laptop" }}
# 仕事用ラップトップ専用設定
export WORK_PROXY="http://proxy.company.com:8080"
{{- end }}
```

### Tip 3: 暗号化設定の管理

```bash
# SSH configを暗号化して追加
chezmoi add --encrypt ~/.ssh/config

# 編集（自動的に復号化される）
chezmoi edit ~/.ssh/config
```

---

## 📊 まとめ

このdotfilesリポジトリのクロスプラットフォーム対応：

| 項目 | macOS | Linux | Windows |
|------|-------|-------|---------|
| パッケージマネージャー | Homebrew | apt/dnf/pacman | Scoop |
| Homebrewパス | `/opt/homebrew` | `/home/linuxbrew/.linuxbrew` | - |
| クリップボード | `pbcopy` | `xclip` | `clip.exe` |
| Git認証 | osxkeychain | libsecret | manager-core |
| pnpmパス | `~/Library/pnpm` | `~/.local/share/pnpm` | `~/.local/share/pnpm` |

すべて**自動的に切り替わります**！
