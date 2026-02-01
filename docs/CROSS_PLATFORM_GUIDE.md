# chezmoiクロスプラットフォームガイド

chezmoiは複数のOS（macOS、Linux、Windows）間での設定ファイル管理に優れた機能を提供します。

## 🎯 プラットフォーム検出

chezmoiは自動的に以下の変数を提供します：

```go-template
{{ .chezmoi.os }}           // "darwin", "linux", "windows"
{{ .chezmoi.osRelease }}    // OS詳細情報
{{ .chezmoi.arch }}         // "amd64", "arm64"
{{ .chezmoi.hostname }}     // ホスト名
{{ .chezmoi.username }}     // ユーザー名
```

## 📁 ファイル名による条件分岐

### 1. OS別ファイル（最も簡単）

ファイル名に修飾子を付けることで、特定のOSでのみ適用されます：

```
home/
├── dot_bashrc                     # 全OS共通
├── dot_bashrc.tmpl               # テンプレート版（全OS）
├── dot_profile_darwin            # macOSのみ
├── dot_profile_linux             # Linuxのみ
├── dot_profile_windows           # Windowsのみ
└── .chezmoiignore               # 除外設定
```

**例：Fish設定をmacOS/Linuxのみに適用**
```
home/
├── dot_config/
│   └── fish_darwin/          # macOSのみ
│       └── config.fish
│   └── fish_linux/           # Linuxのみ
│       └── config.fish
```

### 2. ディレクトリ全体の条件分岐

```
home/
├── .chezmoitemplates/              # テンプレート置き場
├── dot_config/
│   ├── fish_darwin/                # macOSのみ
│   ├── fish_linux/                 # Linuxのみ
│   └── wezterm_darwin_linux/       # macOS & Linux
```

## 🔧 テンプレート内での条件分岐

### 基本的な条件分岐

**`dot_bashrc.tmpl`の例：**
```bash
#!/bin/bash

# 全OS共通設定
export EDITOR=nvim

{{- if eq .chezmoi.os "darwin" }}
# macOS専用設定
export HOMEBREW_PREFIX="/opt/homebrew"
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

# macOS用エイリアス
alias ls='eza --git'
alias cat='bat'
{{- else if eq .chezmoi.os "linux" }}
# Linux専用設定
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# Linux用エイリアス
alias ls='ls --color=auto'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
{{- else if eq .chezmoi.os "windows" }}
# Windows (WSL) 専用設定
export PATH="/mnt/c/Program Files/bin:$PATH"
{{- end }}

# カスタムデータによる分岐
{{- if .work }}
# 仕事用マシン設定
export GIT_AUTHOR_EMAIL="{{ .work_email }}"
{{- else }}
# 個人用マシン設定
export GIT_AUTHOR_EMAIL="{{ .email }}"
{{- end }}
```

### Fish設定の例

**`dot_config/fish/config.fish.tmpl`:**
```fish
## 全OS共通設定
set -x EDITOR nvim

{{- if eq .chezmoi.os "darwin" }}
## macOS専用
set -x HOMEBREW /opt/homebrew
set -x PATH $PATH $HOMEBREW/bin

# macOS用パッケージパス
fish_add_path /opt/homebrew/opt/mysql-client@5.7/bin
{{- else if eq .chezmoi.os "linux" }}
## Linux専用
set -x PATH $PATH /home/linuxbrew/.linuxbrew/bin

# Linux用クリップボード
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
{{- end }}

## 共通エイリアス
alias vim='nvim'
alias ls='eza --git'
```

## 🚀 スクリプトの条件実行

### OS別インストールスクリプト

**ファイル名で分岐：**
```
home/.chezmoiscripts/
├── run_once_before_install-packages_darwin.sh    # macOSのみ
├── run_once_before_install-packages_linux.sh     # Linuxのみ
└── run_once_before_install-packages_windows.ps1  # Windowsのみ
```

**テンプレート内で分岐：**

**`run_once_before_install-packages.sh.tmpl`:**
```bash
#!/bin/bash

{{- if eq .chezmoi.os "darwin" }}
# macOS: Homebrew
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install fish tmux neovim eza bat tig ghq

{{- else if eq .chezmoi.os "linux" }}
# Linux: apt/yum/pacman
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y fish tmux neovim bat
elif command -v pacman &> /dev/null; then
    sudo pacman -S fish tmux neovim bat
fi

{{- else if eq .chezmoi.os "windows" }}
# Windows: Scoop or winget
if ! command -v scoop &> /dev/null; then
    powershell -Command "iwr -useb get.scoop.sh | iex"
fi

scoop install fish neovim
{{- end }}
```

## 📝 設定データの管理

### `~/.config/chezmoi/chezmoi.toml`でマシン固有設定

```toml
[data]
    email = "your-email@example.com"
    name = "Your Name"

    # マシンタイプ（カスタム変数）
    work = false
    work_email = "work@company.com"

    # プラットフォーム固有設定
    [data.darwin]
        homebrew_prefix = "/opt/homebrew"

    [data.linux]
        homebrew_prefix = "/home/linuxbrew/.linuxbrew"
```

### テンプレートでの使用例

```bash
{{- if .work }}
export GIT_AUTHOR_EMAIL="{{ .work_email }}"
{{- else }}
export GIT_AUTHOR_EMAIL="{{ .email }}"
{{- end }}

{{- if eq .chezmoi.os "darwin" }}
export HOMEBREW_PREFIX="{{ .darwin.homebrew_prefix }}"
{{- end }}
```

## 🎨 実践例：このリポジトリでの実装

### 1. Fish設定をクロスプラットフォーム対応

**現在：**
```
home/dot_config/fish/config.fish
```

**改良案：**
```
home/dot_config/fish/config.fish.tmpl
```

**内容：**
```fish
## 共通設定
set -x EDITOR nvim

{{- if eq .chezmoi.os "darwin" }}
## macOS
set -x HOMEBREW /opt/homebrew
set -x PATH $PATH $HOMEBREW/bin
alias ls='eza --git'
{{- else if eq .chezmoi.os "linux" }}
## Linux
set -x PATH $PATH /home/linuxbrew/.linuxbrew/bin
alias pbcopy='xclip -selection clipboard'
alias ls='eza --color=auto'
{{- end }}

## 共通エイリアス
alias vim='nvim'
alias cat='bat'
```

### 2. インストールスクリプトの分岐

**ファイル構成：**
```
home/.chezmoiscripts/
├── run_once_before_install-packages_darwin.sh
├── run_once_before_install-packages_linux.sh
└── run_once_after_setup-fish.sh.tmpl
```

**`run_once_before_install-packages_darwin.sh`（macOS専用）:**
```bash
#!/bin/bash
brew install fish tmux neovim eza bat tig ghq
```

**`run_once_before_install-packages_linux.sh`（Linux専用）:**
```bash
#!/bin/bash
sudo apt install -y fish tmux neovim bat
```

## 🔍 .chezmoiignoreでの条件除外

**`.chezmoiignore`:**
```
# macOS以外で.Brewfileを無視
{{ if ne .chezmoi.os "darwin" }}
.Brewfile
{{ end }}

# Linux以外でapt設定を無視
{{ if ne .chezmoi.os "linux" }}
.config/apt/
{{ end }}

# Windows以外でPowerShell設定を無視
{{ if ne .chezmoi.os "windows" }}
.config/powershell/
{{ end }}

# 仕事用マシン以外で仕事用設定を無視
{{ if not .work }}
.ssh/work_*
.config/work/
{{ end }}
```

## 📊 完全な例：複数OS対応dotfiles構造

```
~/.local/share/chezmoi/
├── home/
│   ├── .chezmoi.toml.tmpl
│   ├── .chezmoiignore
│   │
│   ├── .chezmoiscripts/
│   │   ├── run_once_before_install_darwin.sh      # macOSのみ
│   │   ├── run_once_before_install_linux.sh       # Linuxのみ
│   │   └── run_once_after_setup-shell.sh.tmpl     # 全OS（内部で分岐）
│   │
│   ├── dot_bashrc.tmpl                            # 全OS（テンプレート）
│   ├── dot_zshrc.tmpl                             # 全OS（テンプレート）
│   │
│   ├── dot_config/
│   │   ├── fish/
│   │   │   ├── config.fish.tmpl                   # 全OS（テンプレート）
│   │   │   └── functions/
│   │   │       ├── common.fish                    # 全OS共通
│   │   │       ├── darwin.fish_darwin             # macOSのみ
│   │   │       └── linux.fish_linux               # Linuxのみ
│   │   │
│   │   ├── nvim/                                  # 全OS共通
│   │   │   └── init.lua
│   │   │
│   │   ├── wezterm_darwin/                        # macOSのみ
│   │   │   └── wezterm.lua
│   │   │
│   │   ├── alacritty_linux/                       # Linuxのみ
│   │   │   └── alacritty.yml
│   │   │
│   │   └── powershell_windows/                    # Windowsのみ
│   │       └── Microsoft.PowerShell_profile.ps1
│   │
│   ├── dot_tmux.conf                              # 全OS共通
│   ├── dot_gitconfig.tmpl                         # 全OS（テンプレート）
│   │
│   └── Library_darwin/                            # macOSのみ
│       └── Application Support/
```

## 🛠️ チートシート

| 用途 | 方法 | 例 |
|------|------|-----|
| macOSのみ | ファイル名に`_darwin` | `config_darwin.fish` |
| Linuxのみ | ファイル名に`_linux` | `bashrc_linux` |
| Windowsのみ | ファイル名に`_windows` | `profile_windows.ps1` |
| 複数OS | `_darwin_linux` | `tmux.conf_darwin_linux` |
| テンプレート分岐 | `.tmpl`拡張子 + `{{ if }}` | `config.fish.tmpl` |
| 除外 | `.chezmoiignore` | 条件付き除外 |
| スクリプト分岐 | `_darwin.sh` / `.sh.tmpl` | OS別インストール |

## 📚 参考リンク

- [chezmoi公式: テンプレート](https://www.chezmoi.io/user-guide/templating/)
- [chezmoi公式: クロスプラットフォーム](https://www.chezmoi.io/user-guide/machines/)
- [テンプレート関数リファレンス](https://www.chezmoi.io/reference/templates/)
