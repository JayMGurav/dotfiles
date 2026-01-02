#!/usr/bin/env bash
set -e

echo "🔍 Checking symlinks..."

test -L ~/.zshrc
test -L ~/.gitconfig
test -L ~/.config/ghostty/config
test -L ~/.config/starship/starship.toml

echo "🔍 Checking tools..."

command -v git
command -v fzf
command -v rg
command -v bat
command -v eza
command -v starship

echo "🔍 Checking zsh startup..."
zsh -i -c exit

echo "✅ All checks passed"
