# dotfiles

Minimal personal zsh setup for macOS. No Homebrew, no oh-my-zsh — just:

- A handful of aliases
- [Starship](https://starship.rs) for the prompt
- FiraCode Nerd Font + a matching Terminal.app profile

## Install

On a fresh Mac:

```bash
git clone https://github.com/RenegadeFox/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

When the script finishes, a new Terminal window will open using the
`FiraCode` profile with the new prompt. That window is the signal that
the install is done — you can close the original.

> The repo can live anywhere; `install.sh` resolves its own path. `~/.dotfiles` is just convention.

## What the installer does

1. Copies `fonts/*.ttf` into `~/Library/Fonts/` (no `sudo` needed).
2. Installs Starship via the official one-liner.
3. Symlinks `zsh/zshrc` → `~/.zshrc`.
4. Imports the `FiraCode.terminal` profile and sets it as the default + startup profile for Terminal.app.
5. Opens a new Terminal window using that profile.

## Layout

```
.
├── README.md
├── install.sh
├── fonts/                   # FiraCode Nerd Font TTFs
├── terminal/
│   └── FiraCode.terminal    # exported Terminal.app profile
└── zsh/
    ├── zshrc                # → ~/.zshrc
    └── aliases.zsh          # sourced from zshrc
```

## Aliases

| Command | Does                                         |
| ------- | -------------------------------------------- |
| `c`     | `clear`                                      |
| `ll`    | Long listing of current dir                  |
| `cll`   | `clear` + `ll`                               |
| `cdl`   | `cd` then `ll`. With no arg, cd's to `$HOME` |

Add or edit them in `zsh/aliases.zsh`, then `source ~/.zshrc` (or open a new shell).

## Updating

```bash
cd ~/.dotfiles
git pull
```

Edits to `aliases.zsh` and `zshrc` take effect on the next shell. Font
or Terminal-profile changes need `install.sh` re-run.

## Uninstall

```bash
rm ~/.zshrc
rm ~/Library/Fonts/FiraCode*.ttf
# Then in Terminal > Settings, switch the default profile back to "Basic"
# and delete the FiraCode profile.
# To remove Starship: rm "$(which starship)"
```
