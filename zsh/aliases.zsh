alias c="clear"
alias cll="clear;list_dir_contents"
alias ll="list_dir_contents"
alias cdl="change_dir_clear_and_list"
alias aliases="alias | sort"
alias df-update="update_dotfiles"

# dotfiles reinstall if fonts, terminal profile, or other files other than alias were updated.
alias df-reinstall="zsh $DOTFILES/install.sh"


# Functions

# Change directory and list contents
# Usage: cd [directory]
# If no directory is provided, the default is $HOME
change_dir_clear_and_list() {
  local target_dir="${1:-$HOME}"

  if builtin cd "$target_dir"; then
    list_dir_contents
  fi
}

# List the contents of the current directory
# Check if exa is installed, and use it if available,
# otherwise fallback to using ls
list_dir_contents() {
  # If exa is installed, use it
  if command -v eza >/dev/null 2>&1; then
    # List contents using exa
    eza -lha --color=always --group-directories-first --no-file-size --no-time
  else
    # List contents using ls
    ls -la --color=always
  fi
}

# Pull latest dotfiles and reload shell config
update_dotfiles() {
  ( cd "$DOTFILES" && git pull ) && exec zsh
}
