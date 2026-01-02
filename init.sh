#!/usr/bin/env bash
set -e

# ----------------------------------
# Step 0: Homebrew check
# ----------------------------------
echo "🔍 Checking Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🔍 Checking just..."
if ! command -v just >/dev/null 2>&1; then
  echo "📦 Installing just..."
  brew install just
fi

brew update


echo "🚀 Running bootstrap..."

# Make check script executable
chmod +x ./scripts/check.sh

echo "🚀 Running bootstrap..."
just bootstrap

echo "installing sdkman"
just sdkman