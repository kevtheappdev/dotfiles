#!/bin/bash

# Dotfiles Installation Script
# This script sets up Oh My Zsh, Powerlevel10k, and iTerm2 configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only."
    exit 1
fi

print_status "Starting dotfiles installation..."

# Get the directory where the script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_status "Dotfiles directory: $DOTFILES_DIR"

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    print_status "Homebrew already installed"
fi

# Install required packages
print_status "Installing required packages..."
brew install findutils gnu-getopt make util-linux chruby

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_status "Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    print_status "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    print_status "Powerlevel10k already installed"
fi

# Install zsh plugins
print_status "Installing zsh plugins..."

# zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    print_status "zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    print_status "zsh-syntax-highlighting already installed"
fi

# Backup existing dotfiles
print_status "Backing up existing dotfiles..."
mkdir -p "$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Backup existing files if they exist
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc.backup"
[ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$BACKUP_DIR/.p10k.zsh.backup"
[ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ] && cp "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "$BACKUP_DIR/com.googlecode.iterm2.plist.backup"

# Create symlinks
print_status "Creating symlinks..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# Copy iTerm2 preferences (symlink doesn't work well with plist files)
if [ -f "$DOTFILES_DIR/com.googlecode.iterm2.plist" ]; then
    print_status "Installing iTerm2 preferences..."
    cp "$DOTFILES_DIR/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
    # Restart iTerm2's preferences system
    defaults read com.googlecode.iterm2 > /dev/null 2>&1 || true
fi

# Install fonts for Powerlevel10k and general powerline compatibility
print_status "Installing powerline-compatible fonts..."
FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"

# Install MesloLGS NF fonts (recommended for Powerlevel10k)
print_status "Installing MesloLGS NF fonts (Powerlevel10k recommended)..."
for font in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
    if [ ! -f "$FONT_DIR/$font" ]; then
        curl -fLo "$FONT_DIR/$font" "https://github.com/romkatv/powerlevel10k-media/raw/master/$font"
    fi
done

# Install additional powerline fonts for broader compatibility
print_status "Installing additional Powerline fonts..."
POWERLINE_FONTS_DIR="/tmp/powerline-fonts"
if [ ! -d "$POWERLINE_FONTS_DIR" ]; then
    git clone https://github.com/powerline/fonts.git "$POWERLINE_FONTS_DIR" --depth=1
    cd "$POWERLINE_FONTS_DIR"
    ./install.sh
    cd - > /dev/null
    rm -rf "$POWERLINE_FONTS_DIR"
    print_status "Powerline fonts installed successfully"
else
    print_status "Powerline fonts already downloaded"
fi

# Install Ruby (if chruby is available)
if command -v chruby &> /dev/null; then
    if ! chruby | grep -q "ruby-3.3.5"; then
        print_status "Installing Ruby 3.3.5..."
        if command -v ruby-install &> /dev/null; then
            ruby-install ruby 3.3.5
        else
            print_warning "ruby-install not found. Install it manually: brew install ruby-install"
        fi
    else
        print_status "Ruby 3.3.5 already installed"
    fi
fi

# Install bun if not already installed
if ! command -v bun &> /dev/null; then
    print_status "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
else
    print_status "bun already installed"
fi

print_status "Dotfiles installation complete!"
print_status "Backup of your previous configuration saved to: $BACKUP_DIR"
print_warning "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
print_warning "If using iTerm2, restart the application to apply the new preferences."

# Change default shell to zsh if not already
if [[ "$SHELL" != */zsh ]]; then
    print_status "Changing default shell to zsh..."
    chsh -s $(which zsh)
    print_warning "You may need to log out and back in for the shell change to take effect."
fi

print_status "Setup complete! 🎉"