set shell := ["zsh", "-cu"]

# Stow packages. Each must contain the target path relative to $HOME
# (e.g. bat/.config/bat/config), NOT a bare file.
packages := "git zsh starship bat ghostty karabiner"

default:
	@just --list

bootstrap:
	@echo "🍺 Installing Homebrew bundles..."
	brew bundle --verbose --file=install/brew/Brewfile

	# Stow BEFORE sdkman: the sdkman installer appends its init lines to
	# ~/.zshrc only if they are missing. Stowing first means our .zshrc
	# (which already has them) is in place, so the installer leaves it alone.
	@echo "🔗 Stowing dotfiles..."
	just stow

	@echo "💻 Installing SDKMAN..."
	just sdkman

	@echo "🍎 Applying macOS defaults..."
	bash setup/macos/defaults.sh

	@echo "✅ Bootstrap complete — restart your shell: exec zsh"

# Symlink dotfiles into $HOME.
# NOTE: no --adopt. --adopt overwrites repo files with whatever is in $HOME,
# which silently imports local drift into version control.
stow:
	cd config && stow --verbose --no-folding --target="$HOME" {{ packages }}

# Preview what stow would do without touching the filesystem.
stow-dry:
	cd config && stow --simulate --verbose --no-folding --target="$HOME" {{ packages }}

# Remove all symlinks this repo owns.
unstow:
	cd config && stow --delete --verbose --target="$HOME" {{ packages }}

# Re-link after adding or renaming files.
restow:
	cd config && stow --restow --verbose --no-folding --target="$HOME" {{ packages }}

sdkman:
	#!/usr/bin/env bash
	set -euo pipefail
	if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
	  echo "💻 SDKMAN already installed, skipping."
	else
	  echo "💻 Installing SDKMAN..."
	  curl -s "https://get.sdkman.io" | bash
	fi

# Update everything.
update:
	brew update && brew upgrade && brew bundle --file=install/brew/Brewfile
	brew cleanup

check:
	bash scripts/check.sh
