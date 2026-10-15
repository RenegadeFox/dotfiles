#!/bin/zsh --no-rcs
# Fail early if errors are found
set -euo pipefail

# --- Global Constants ---

# Resolve install directory of this script
DOTFILES="${0:A:h}"
# Terminal profile name
TERM_PROFILE_NAME="FiraCode"
# Current date and time for backups
CURRENT_DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)
# Backup directory for existing configs with date and time
BACKUP_DIR="$HOME/.dotfiles_backup/$CURRENT_DATE_TIME"

# --- Parse Install Flags ---

local skip_terminal=false
local skip_fonts=false
local skip_starship=false

zparseopts -D -E \
  -no-terminal=_nt \
  -no-fonts=_nf \
  -no-starship=_ns \
  -help=_help

[[ -n "$_nt" ]] && skip_terminal=true
[[ -n "$_nf" ]] && skip_fonts=true
[[ -n "$_ns" ]] && skip_starship=true

# Display help message if help flag is passed
if [[ -n "$_help" ]]; then
  cat << EOF
Usage: install.sh [options]

Options:
  --no-terminal    Skip Terminal.app profile setup
  --no-fonts       Skip font installation
  --no-starship    Skip Starship installation
  --help           Show this message
EOF
  exit 0
fi

# --- Setup Required Directories ---

echo -n "Setting up required directories..."

# Ensure ~/.config exists
mkdir -p "$HOME/.config"
# Create the backup directory
mkdir -p "$BACKUP_DIR"
# Create user fonts directory if it doesn't exist
if [[ ! -f "$HOME/Library/Fonts" ]]; then
  mkdir -p "$HOME/Library/Fonts"
fi
# Create the local bin directory if it doesn't exist
if [[ ! -f "$HOME/.local/bin" ]]; then
  mkdir -p "$HOME/.local/bin"
fi

echo "✅ Done"

# --- Backup Old Config Files ---

echo -n "Backing up current config files..."

# Backup current .zshrc and startship.toml configs if they exist
if [ -e "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$BACKUP_DIR/zshrc.backup"
fi
if [ -e "$HOME/.config/starship.toml" ]; then
  mv "$HOME/.config/starship.toml" "$BACKUP_DIR/starship.toml.backup"
fi

echo "✅ done"

# --- Install Config Files ---

echo -n "Installing config files..."

# Render zshrc with the actual DOTFILES path baked in
sed "s|__DOTFILES_PATH__|$DOTFILES|g" "$DOTFILES/zsh/zshrc" > "$DOTFILES/zsh/zshrc.generated"

# Symlink config files
# ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/zshrc.generated" "$HOME/.zshrc"
ln -sf "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

echo "✅ done"

# --- Install Starship and Associated Files ---

if [[ "$skip_fonts" == false ]]; then
  echo -n "Installing fonts..."

  # Copy font(s) to user's fonts directory
  cp "$DOTFILES"/fonts/*.ttf "$HOME/Library/Fonts/"

  echo "✅ done"
fi

if [[ "$skip_starship" == false ]]; then
  echo -n "Installing Starship..."

  # Install Starship unattended in user's local bin directory
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"

  echo "✅ done"
fi

# --- Configure Terminal with Profile ---

if [[ "$skip_terminal" == false ]]; then
  echo -n "Installing Terminal profiles..."

  # Register the Terminal profile and set it as default
  # Sleep between to allow Terminal to register it properly first
  open "$DOTFILES/terminal/$TERM_PROFILE_NAME.terminal"
  sleep 1
  defaults write com.apple.Terminal "Default Window Settings" -string "$TERM_PROFILE_NAME"
  defaults write com.apple.Terminal "Startup Window Settings" -string "$TERM_PROFILE_NAME"

  echo "✅ done"
fi
