# List all custom aliases/functions with descriptions
aliases() {
  # Manually set array of custom aliases/functions
  local -A cmds=(
    "c"           "Clear the terminal"
    "ll"          "List directory contents (long format)"
    "cll"         "Clear the terminal and then list directory contents (long format)"
    "cdl"         "Change directory and list contents (long format)"
    "df-update"   "Pull latest dotfiles from GitHub repo and reload the shell"
    "df-reinstal" "Re-run the dotfiles installer with optional flags"
    "aliases"     "Show this list"
  )

  echo ""
  # Iterate over the above array and display it
  for key in "${(@ok)cmds}"; do
    printf " \033[1;36m%-16s\033[0m %s\n" "$key" "$cmds[$key]"
  done
  echo ""
}

alias c="clear"
alias cll="clear;list_directory_contents"
alias ll="list_directory_contents"
alias df-update="update_dotfiles"
alias df-reinstall="reinstall_dotfiles"

# Functions

# Get bundle ID of app from path
bundle_id() {
  codesign -dv "$@" 2>&1 | /usr/bin/awk -F'=' '/^Identifier/ { print $2 }'
}

# Change directory and list contents
# Usage: cd [directory]
# If no directory is provided, the default is $HOME
cdl() {
  local target_dir="${1:-$HOME}"

  if builtin cd "$target_dir"; then
    list_directory_contents
  fi
}

# List the contents of the current directory
# Check if exa is installed, and use it if available,
# otherwise fallback to using ls
list_directory_contents() {
  # If exa is installed, use it
  if command -v eza >/dev/null 2>&1; then
    # List contents using exa
    eza -lha --color=always --group-directories-first --no-filesize --no-time
  else
    # List contents using ls
    ls -la --color=always
  fi
}

# Pull latest dotfiles and reload shell config
update_dotfiles() {
  ( cd "$DOTFILES" && git pull ) && exec zsh
}

reinstall_dotfiles() {
  # Re-run the installer with the same optional flags
  zsh "$DOTFILES/install.sh" "$@"
}
