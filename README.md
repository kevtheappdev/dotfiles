# Kevin's Dotfiles

A collection of configuration files for setting up a consistent development environment across macOS machines.

## What's Included

- **Zsh Configuration** (`.zshrc`) - Oh My Zsh setup with useful plugins
- **Powerlevel10k Theme** (`.p10k.zsh`) - Beautiful and informative shell prompt
- **iTerm2 Preferences** - Terminal emulator configuration
- **Automated Install Script** - One-command setup for new machines

## Features

### Shell Setup
- **Oh My Zsh** - Framework for managing Zsh configuration
- **Powerlevel10k** - Fast, customizable prompt with Git integration
- **Plugins**:
  - `git` - Git aliases and functions
  - `zsh-autosuggestions` - Command suggestions based on history
  - `zsh-syntax-highlighting` - Real-time syntax highlighting

### Development Tools
- **Homebrew Utilities** - GNU tools (findutils, gnu-getopt, make, util-linux)
- **Ruby Management** - chruby for Ruby version switching
- **JavaScript Runtime** - Bun for fast JavaScript/TypeScript execution
- **Custom Aliases** - Convenient shortcuts (e.g., `typora` command)

### Terminal Experience
- **MesloLGS NF Font** - Nerd Font with proper powerline symbols
- **iTerm2 Configuration** - Optimized settings for development work

## Quick Setup

### New Machine Setup
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Manual Setup
If you prefer to install components individually:

1. **Install Oh My Zsh**:
   ```bash
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. **Install Powerlevel10k**:
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```

3. **Install Zsh Plugins**:
   ```bash
   # zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   
   # zsh-syntax-highlighting
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

4. **Create Symlinks**:
   ```bash
   ln -sf ~/dotfiles/.zshrc ~/.zshrc
   ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
   ```

5. **Install iTerm2 Preferences**:
   ```bash
   cp ~/dotfiles/com.googlecode.iterm2.plist ~/Library/Preferences/
   ```

## Dependencies

The install script will automatically install these dependencies via Homebrew:

- `findutils` - GNU find, locate, updatedb, and xargs
- `gnu-getopt` - GNU getopt
- `make` - GNU make
- `util-linux` - Various utilities
- `chruby` - Ruby version manager

## Font Requirements

Powerlevel10k requires powerline-compatible fonts for proper display of icons and symbols. The install script automatically installs:

1. **MesloLGS NF** - Recommended font optimized specifically for Powerlevel10k
2. **Powerline Fonts Collection** - Broader set of fonts for maximum compatibility

### Included Font Families
- **MesloLGS NF** (Regular, Bold, Italic, Bold Italic) - Primary recommendation
- **Source Code Pro for Powerline** - Clean, readable programming font
- **DejaVu Sans Mono for Powerline** - Excellent Unicode coverage
- **Liberation Mono for Powerline** - Metric-compatible with other fonts
- **Meslo for Powerline** - Apple's Menlo with powerline symbols
- **And many more from the [Powerline Fonts](https://github.com/powerline/fonts) collection**

### Manual Font Installation
If you need to install fonts manually:

**MesloLGS NF (Powerlevel10k optimized):**
```bash
cd ~/Library/Fonts
curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fLo "MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fLo "MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fLo "MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
```

**Full Powerline Fonts Collection:**
```bash
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
```

## Customization

### Reconfigure Powerlevel10k
```bash
p10k configure
```

### Update Oh My Zsh
```bash
omz update
```

### Add Custom Aliases
Edit the `.zshrc` file in this repository and add your aliases in the user configuration section.

## Files Structure

```
dotfiles/
├── .zshrc                           # Zsh configuration
├── .p10k.zsh                       # Powerlevel10k configuration
├── com.googlecode.iterm2.plist     # iTerm2 preferences
├── install.sh                      # Automated setup script
└── README.md                       # This file
```

## Backup

The install script automatically creates backups of your existing configuration files in `~/.dotfiles_backup/` with a timestamp.

## Troubleshooting

### Zsh Not Default Shell
```bash
chsh -s $(which zsh)
```

### Powerlevel10k Not Working
1. Ensure you're using a Nerd Font (MesloLGS NF recommended)
2. Run `p10k configure` to reconfigure
3. Restart your terminal

### iTerm2 Preferences Not Applied
1. Restart iTerm2 completely
2. Check that the plist file was copied correctly
3. You may need to manually import preferences: iTerm2 → Preferences → General → Preferences → Load preferences from a custom folder

### Plugin Issues
```bash
# Reinstall Oh My Zsh plugins
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
# Then run install script again or install manually
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues and enhancement requests!