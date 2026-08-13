#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# ----------------------------------
# Step 0: Homebrew
# ----------------------------------
echo "🔍 Checking Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew is not on PATH yet in a fresh shell on Apple Silicon.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ----------------------------------
# Step 1: just
# ----------------------------------
echo "🔍 Checking just..."
if ! command -v just >/dev/null 2>&1; then
  echo "📦 Installing just..."
  brew install just
fi

brew update

# ----------------------------------
# Step 2: bootstrap (brew -> stow -> sdkman -> macos defaults)
# ----------------------------------
echo "🚀 Running bootstrap..."
just bootstrap

echo "✅ Done. Restart your shell: exec zsh"
