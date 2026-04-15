#!/bin/zsh --no-rcs
# Fail early if errors are found
set -euo pipefail

# Resolve install directory of this script
DOTFILES="${0:A:h}"

# Terminal profile name
TERM_PROFILE_NAME="FiraCode"

# Current date and time for backups
CURRENT_DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)

# Backup directory for existing configs with date and time
BACKUP_DIR="$HOME/.dotfiles_backup/$CURRENT_DATE_TIME"

# Ensure ~/.config exists
mkdir -p "$HOME/.config"
# Create the backup directory
mkdir -p "$BACKUP_DIR"

# Backup current .zshrc and startship.toml configs if they exist
if [ -e "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$BACKUP_DIR/zshrc.backup"
fi
if [ -e "$HOME/.config/starship.toml" ]; then
  mv "$HOME/.config/starship.toml" "$BACKUP_DIR/starship.toml.backup"
fi

# Render zshrc with the actual DOTFILES path baked in
sed "s|__DOTFILES_PATH__|$DOTFILES|g" "$DOTFILES/zsh/zshrc" > "$DOTFILES/zsh/zshrc.generated"

# Symlink config files
# ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/zshrc.generated" "$HOME/.zshrc"
ln -sf "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

# Copy font(s) to user's fonts directory
cp "$DOTFILES"/fonts/*.ttf "$HOME/Library/Fonts/"

# Install Starship unattended in user's local bin directory
curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"

# Register the Terminal profile and set it as default
# Sleep between to allow Terminal to register it properly first
open "$DOTFILES/terminal/$TERM_PROFILE_NAME.terminal"
sleep 1
defaults write com.apple.Terminal "Default Window Settings" -string "$TERM_PROFILE_NAME"
defaults write com.apple.Terminal "Startup Window Settings" -string "$TERM_PROFILE_NAME"
