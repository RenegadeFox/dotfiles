# dotfiles

Minimal personal zsh setup for macOS. No Homebrew, no oh-my-zsh — just:

- A handful of aliases and helper functions
- [Starship](https://starship.rs) for the prompt
- [FiraCode Nerd Font](https://www.nerdfonts.com) + a matching Terminal.app profile

## Install

```bash
git clone https://github.com/RenegadeFox/dotfiles.git ~/.dotfiles && zsh ~/.dotfiles/install.sh
```

When the script finishes, a new Terminal window will open using the
`FiraCode` profile with the Starship prompt. That window is the signal
that the install is done — you can close the original.

### Installer flags

Skip parts of the install that don't apply to your machine:

```bash
zsh ~/.dotfiles/install.sh --no-terminal    # skip Terminal.app profile setup
zsh ~/.dotfiles/install.sh --no-fonts       # skip font installation
zsh ~/.dotfiles/install.sh --no-starship    # skip Starship installation
```

Flags can be combined:

```bash
zsh ~/.dotfiles/install.sh --no-terminal --no-fonts
```

Run `zsh ~/.dotfiles/install.sh --help` for the full list.

## What the installer does

1. Backs up any existing `~/.zshrc` and `~/.config/starship.toml` to `~/.dotfiles_backup/<timestamp>/`.
2. Renders `zsh/zshrc` with the actual repo path baked in and symlinks it to `~/.zshrc`.
3. Symlinks `starship/starship.toml` → `~/.config/starship.toml`.
4. Copies `fonts/*.ttf` into `~/Library/Fonts/` (no `sudo` needed).
5. Installs Starship to `~/.local/bin` (no Homebrew required).
6. Imports the `FiraCode.terminal` profile and sets it as the default for Terminal.app.

Steps 4–6 can each be skipped with the `--no-*` flags above.

## Layout

```
.
├── README.md
├── install.sh
├── .gitignore
├── fonts/                   # FiraCode Nerd Font TTFs
├── starship/
│   └── starship.toml        # → ~/.config/starship.toml
├── terminal/
│   └── FiraCode.terminal    # exported Terminal.app profile
└── zsh/
    ├── zshrc                # template → rendered to zshrc.generated → ~/.zshrc
    └── aliases.zsh          # sourced from zshrc
```

## Commands

Run `aliases` in the terminal to see this list at any time.

| Command        | Description                                 |
| -------------- | ------------------------------------------- |
| `c`            | Clear the terminal                          |
| `ll`           | List directory contents (long format)       |
| `cll`          | Clear terminal then list directory contents |
| `cdl`          | Change directory and list contents          |
| `df-update`    | Pull latest dotfiles and reload shell       |
| `df-reinstall` | Re-run the dotfiles installer               |
| `aliases`      | Show all available commands                 |

Edit or add aliases in `zsh/aliases.zsh`. Changes take effect on the next
shell or after running `df-update`.

## Updating

From any directory:

```bash
df-update
```

This pulls the latest changes from the repo and reloads the shell.
If the update includes changes to fonts, the Terminal profile, or
`install.sh` itself, run `df-reinstall` instead (flags are supported):

```bash
df-reinstall
df-reinstall --no-terminal
```

## Uninstall

```bash
rm ~/.zshrc
rm ~/Library/Fonts/FiraCode*.ttf
rm ~/.config/starship.toml
rm -rf ~/.dotfiles
# To remove Starship: rm "$(which starship)"
# In Terminal > Settings, switch the default profile back to "Basic"
# and delete the FiraCode profile.
```
