#!/usr/bin/env bash
set -euo pipefail

# Dock
defaults write com.apple.dock autohide -bool false                            # Don't auto-hide Dock
defaults write com.apple.dock show-process-indicators -bool true              # Show indicators for open apps
defaults write com.apple.dock tilesize -int 32                                # Dock size (small)
defaults write com.apple.dock magnification -bool false                       # Disable magnification
defaults write com.apple.dock orientation -string "bottom"                    # Dock position
defaults write com.apple.dock persistent-apps -array                          # Clear default Dock icons
defaults write com.apple.dock minimize-to-application -bool true              # Minimise windows into app icon

# Finder
defaults write -g AppleShowAllExtensions -bool true
defaults write -g AppleLanguages -array "en-IE"                               # Language: English (Ireland)
defaults write -g AppleLocale -string "en_IE"
defaults write com.apple.finder AppleShowAllFiles -bool true                  # Show hidden files
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"           # List view by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"           # Search current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false    # Disable extension change warning
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # No .DS_Store on network & USB
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Menu Bar
defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm"       # Day of week + 24h time
defaults write com.apple.menuextra.battery ShowPercent -bool true             # Show battery percentage
defaults write com.apple.controlcenter BatteryShowPercentage -bool true       # Show battery percentage in Control Center

# Keyboard, Trackpad & Mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButtonRight"  # Right‑click
defaults write com.apple.BezelServices kDim -bool true                        # Auto keyboard backlight
defaults write -g com.apple.mouse.scaling -float 3.0                          # Mouse tracking speed (fast)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true # Enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true      # Enable right-click
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true   # Enable secondary click

# Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots" 
defaults write com.apple.screencapture type -string "png" 

# Misc
defaults write com.apple.loginwindow NSQuitAlwaysKeepsWindows -bool false     # Close windows when quitting apps
defaults write com.apple.spaces spans-displays -bool false                    # Displays have separate spaces
defaults write com.apple.LaunchServices LSQuarantine -bool false              # Disable download quarantine
command -v "Google Chrome" >/dev/null 2>&1 && \
  open -a "Google Chrome" --args --make-default-browser || true

# Apply Changes
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true

