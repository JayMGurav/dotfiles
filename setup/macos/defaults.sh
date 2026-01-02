#!/usr/bin/env bash

echo "Applying macOS defaults..."

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock orientation -string "left"

# Keyboard
# set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad
# defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Screenshot location
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots

# Restart affected apps
killall Finder Dock SystemUIServer || true

# Menu Bar: show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

echo "macOS defaults applied ✅"
