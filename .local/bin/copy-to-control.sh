#!/usr/bin/env bash
# Copy browser profiles to a control location, alias: ctc

# Strict bash execution mode
set -euo pipefail

# Ensure the destination directory exists
dest="$HOME/BrowserProfiles"
if [ ! -d "$dest" ]; then
  echo "Destination directory $dest does not exist. Creating it."
  mkdir -p "$dest"
fi

# Define paths
bcache="$HOME/.cache/BraveSoftware/Brave-Browser"
bconf="$HOME/.config/BraveSoftware"
bcont="$HOME/BrowserProfiles/BraveSoftware"
ccache="$HOME/.cache/chromium"
cconf="$HOME/.config/chromium"
ccont="$HOME/BrowserProfiles/chromium"

# Function to copy profile
copy_profile() {
  local source="$1"
  local target="$2"
  echo "Copying $source profile..."
  cp -r "$source" "$target"
}

# Check and copy Brave profile
if [ -d "$bconf" ]; then
  echo "Removing existing Brave cache and container directories..."
  rm -rf "$bcache" "$bcont"

  copy_profile "$bconf" "$dest"
  echo "Brave profile copied to control."
else
  echo "Brave source directory not present!"
fi

# Check and copy Chromium profile
if [ -d "$cconf" ]; then
  echo "Removing existing Chromium cache and container directories..."
  rm -rf "$ccache" "$ccont"

  copy_profile "$cconf" "$dest"
  echo "Chromium profile copied to control."
else
  echo "Chromium source directory not present!"
fi
