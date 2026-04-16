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
# Directory to store any plugins
PLUGINS_DIR="$DOTFILES/plugins"

# --- Parse Install Flags ---

local skip_terminal=false
local skip_fonts=false
local skip_starship=false
local skip_autosuggestions=false

zparseopts -D -E \
  -no-terminal=_nt \
  -no-fonts=_nf \
  -no-starship=_ns \
  -no-autosuggest=_na \
  -help=_help

[[ -n "$_nt" ]] && skip_terminal=true
[[ -n "$_nf" ]] && skip_fonts=true
[[ -n "$_ns" ]] && skip_starship=true
[[ -n "$_na" ]] && skip_autosuggestions=true

# Display help message if help flag is passed
if [[ -n "$_help" ]]; then
  cat << EOF
Usage: install.sh [options]

Options:
  --no-terminal    Skip Terminal.app profile setup
  --no-fonts       Skip font installation
  --no-starship    Skip Starship installation
  --no-autosuggest Skip installing zsh-autosuggestions
  --help           Show this message
EOF
  exit 0
fi

# --- Setup Required Directories ---

# Ensure ~/.config exists
mkdir -p "$HOME/.config"
# Create the backup directory
mkdir -p "$BACKUP_DIR"
# Create the local bin directory if it doesn't exist
mkdir -p "$HOME/.local/bin"

# --- Backup Old Config Files ---

# Backup current .zshrc and startship.toml configs if they exist
if [ -e "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$BACKUP_DIR/zshrc.backup"
fi
if [ -e "$HOME/.config/starship.toml" ]; then
  mv "$HOME/.config/starship.toml" "$BACKUP_DIR/starship.toml.backup"
fi

# --- Install Config Files ---

# Render zshrc with the actual DOTFILES path baked in
sed "s|__DOTFILES_PATH__|$DOTFILES|g" "$DOTFILES/zsh/zshrc" > "$DOTFILES/zsh/zshrc.generated"

# Symlink config files
ln -sf "$DOTFILES/zsh/zshrc.generated" "$HOME/.zshrc"
ln -sf "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

# --- Install zsh-autosuggestions ---
# https://github.com/zsh-users/zsh-autosuggestions
if [[ "$skip_autosuggestions" == false ]]; then
  if [ -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is already installed"
  else
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
  fi
fi

# --- Install Starship and Associated Files ---
# https://starship.rs

if [[ "$skip_fonts" == false ]]; then
  # Copy font(s) to user's fonts directory
  cp "$DOTFILES"/fonts/*.ttf "$HOME/Library/Fonts/"
fi

if [[ "$skip_starship" == false ]]; then
  # Install Starship unattended in user's local bin directory
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

# --- Configure Terminal with Profile ---

if [[ "$skip_terminal" == false ]]; then
  # Register the Terminal profile and set it as default
  # Sleep between to allow Terminal to register it properly first
  open "$DOTFILES/terminal/$TERM_PROFILE_NAME.terminal"
  sleep 1
  defaults write com.apple.Terminal "Default Window Settings" -string "$TERM_PROFILE_NAME"
  defaults write com.apple.Terminal "Startup Window Settings" -string "$TERM_PROFILE_NAME"
fi
