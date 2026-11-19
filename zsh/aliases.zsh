# Path to my custom Jamf-related scripts
jamf_path="$HOME/dev/Jamf/scripts/"

# List all custom aliases/functions with descriptions
aliases() {
  # Manually set array of custom aliases/functions
  local -A cmds=(
    "c"           "Clear the terminal"
    "ll"          "List directory contents (long format)"
    "cll"         "Clear the terminal and then list directory contents (long format)"
    "cdl"         "Change directory and list contents (long format)"
    "bundleid"    "Get the bundle ID of an app from the passed in path"
    "df-update"   "Pull latest dotfiles from GitHub repo and reload the shell"
    "df-reinstal" "Re-run the dotfiles installer with optional flags"
    "df-regen"    "Re-generates the zshrc.generated file based on the zsh template file and reloads the shell"
    "cropVideo"   "Run ffmpeg video cropping script"
    "cdd"         "cd directly into the ~/Downloads/ folder"
    "icloud"      "cd directly into the iCloud Documents folder"
    "s3list"      "Jamf 400: List files on the AWS S3 bucket"
    "s3upload"    "Jamf 400: Upload the provided file to the S3 bucket"
    "s3checksum"  "Jamf 400: Get the sha256 checksum of the specified file from the S3 bucket"
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
alias update-ssh="zsh $jamf_path/API\ Scripts/updateSSH.sh"
# Regenerate zshrc from template and reload
alias df-regen='sed "s|__DOTFILES_PATH__|$DOTFILES|g" "$DOTFILES/zsh/zshrc" > "$DOTFILES/zsh/zshrc.generated" && exec zsh'
alias cropVideo="bash $HOME/dev/Finn/cropAndConvertVideo.sh"
alias cdd="cd $HOME/Downloads"
alias icloud="cd /Users/martin.cox/Library/Mobile\ Documents/com\~apple\~CloudDocs"

# Jamf 400 Course Aliases
alias s3list="aws s3 ls s3://jamf-400-course/amer/8/ --profile jamftraining"

s3upload() {
  local filePath="$1"
  aws s3 cp "$filePath" s3://jamf-400-course/amer/8/ --profile jamftraining
  echo "URL: https://jamf-400-course.s3.us-east-2.amazonaws.com/amer/8/$filePath"
  echo -n "Checksum: "
  curl -s "https://jamf-400-course.s3.us-east-2.amazonaws.com/amer/8/$filePath" | sha256
}

s3url() {
  local filePath="$1"
  echo "https://jamf-400-course.s3.us-east-2.amazonaws.com/amer/8/$filePath"
}

s3checksum() {
  local filePath="$1"
  curl -s "https://jamf-400-course.s3.us-east-2.amazonaws.com/amer/8/$filePath" | sha256
}

# Functions

# Get bundle ID of app from path
bundleid() {
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
