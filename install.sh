#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "📂 Script dir: $SCRIPT_DIR"
echo "🏠 Home dir  : $HOME_DIR"

# -------------------------
# Detect package manager
# -------------------------
install_pkg() {
  if command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm "$@"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "$@"
  elif command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y "$@"
  else
    echo "❌ Unsupported package manager"
    exit 1
  fi
}

# -------------------------
# Install base tools
# -------------------------
BASE_PKGS=(curl git)

for pkg in "${BASE_PKGS[@]}"; do
  if ! command -v "$pkg" &>/dev/null; then
    echo "📦 Installing $pkg..."
    install_pkg "$pkg"
  else
    echo "✅ $pkg already installed"
  fi
done

# -------------------------
# Install zsh
# -------------------------
if ! command -v zsh &>/dev/null; then
  echo "📦 Installing zsh..."
  install_pkg zsh
else
  echo "✅ zsh already installed"
fi

# -------------------------
# Install tmux  ✅ (PHẦN BẠN YÊU CẦU)
# -------------------------
if ! command -v tmux &>/dev/null; then
  echo "📦 Installing tmux..."
  install_pkg tmux
else
  echo "✅ tmux already installed"
fi

# -------------------------
# Install Neovim
# -------------------------
if ! command -v nvim &>/dev/null; then
  echo "📦 Installing Neovim..."
  install_pkg neovim
else
  echo "✅ Neovim already installed"
fi

# -------------------------
# Install Oh My Zsh
# -------------------------
if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
  echo "✨ Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed"
fi

# -------------------------
# Copy .zshrc
# -------------------------
if [ -f "$SCRIPT_DIR/zsh/.zshrc" ]; then
  echo "📄 Copying .zshrc..."
  cp "$SCRIPT_DIR/zsh/.zshrc" "$HOME_DIR/.zshrc"
else
  echo "⚠️ zsh/.zshrc not found"
fi

# -------------------------
# Neovim config
# -------------------------
mkdir -p "$HOME_DIR/.config"

if [ -d "$SCRIPT_DIR/nvim" ]; then
  rm -rf "$HOME_DIR/.config/nvim"
  cp -r "$SCRIPT_DIR/nvim" "$HOME_DIR/.config/"
  echo "✅ nvim config copied"
else
  echo "⚠️ nvim folder not found"
fi

# -------------------------
# tmux config
# -------------------------
if [ -f "$SCRIPT_DIR/tmux/.tmux.conf" ]; then
  cp "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME_DIR/.tmux.conf"
  echo "✅ .tmux.conf copied"
else
  echo "⚠️ tmux/.tmux.conf not found"
fi

# -------------------------
# Change default shell
# -------------------------
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "🔁 Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
fi

echo "🎉 DONE! Logout/login lại để dùng zsh + tmux."

