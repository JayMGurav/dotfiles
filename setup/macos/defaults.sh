#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults..."

# ============
# Finder
# ============
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Default to list view ("Nlsv"); other options: icnv, clmv, Flwv
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Search the current folder by default instead of the whole Mac
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Don't write .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ============
# Dock
# ============
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock tilesize -int 42
# Remove the autohide delay so the Dock appears instantly
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
# Don't rearrange Spaces by most recent use — keeps Mission Control predictable
defaults write com.apple.dock mru-spaces -bool false

# ============
# Keyboard
# ============
# Fast key repeat. ApplePressAndHoldEnabled must be false or holding a key
# shows the accent-picker popup instead of repeating (breaks vim-style nav).
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Full keyboard access: Tab through every control in dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Disable "smart" substitutions that mangle code and quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ============
# Trackpad
# ============
# Tap to click. Needs -currentHost for the multitouch domain, plus the
# NSGlobalDomain mirror so the setting survives a reboot.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ============
# Screenshots
# ============
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
# Drop the drop-shadow around captured windows
defaults write com.apple.screencapture disable-shadow -bool true

# ============
# Menu bar / Control Center
# ============
# The legacy com.apple.menuextra.battery domain has been ignored since
# Big Sur; battery percentage now lives in Control Center's per-host prefs.
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

# ============
# Misc
# ============
# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# Don't auto-quit the printer app once jobs finish
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Disable the "Are you sure you want to open this application?" quarantine dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ============
# Restart affected apps — must be LAST, after every write above.
# ============
for app in Finder Dock SystemUIServer ControlCenter; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "macOS defaults applied ✅"
echo "Note: some settings (key repeat, tap-to-click) need a logout or reboot."
