# Dotfiles

Opinionated macOS + zsh + Ghostty setup using Homebrew and GNU Stow.

## Structure

- `config/` — all dotfiles (bat, eza, fzf, ghostty, git, karabiner, starship, zsh), symlinked into `$HOME`
- `install/` — Homebrew packages (Brewfile, Brewfile.casks, Brewfile.fonts)
- `scripts/` — utility scripts (check.sh)
- `setup/` — system configuration (macOS defaults)
- `Justfile` — one-command bootstrap and daily workflows
- `init.sh` — initial setup script

## Bootstrap (new machine)

1. Clone the repo: `git clone <repo> ~/dotconfig`
2. cd into: `cd ~/dotconfig`
3. Update permissions: `chmod +x init.sh`
4. Run `./init.sh`

## Daily commands

```bash
just bootstrap   # rerun whenever updating dotfiles or packages
just check       # sanity check | needs fix
```

## Post Install

- `nvm install node`
- `sdk install java`

## Stack
- Shell: zsh
- Terminal: Ghostty
- Prompt: Starship
- Search: fzf + fd + ripgrep
- Navigation: zoxide
- History: atuin
- Package manager: Homebrew
- Dotfiles: GNU Stow

---

## ✅ Final Result

You now have:

- 🔥 fzf-powered Git workflows
- ⭐ Starship tuned for Ghostty
- 🧪 A safety net (`just check`)
- 📖 A clean, honest README
- 🧼 A dotfiles repo that scales without entropy