#!/usr/bin/env bash
# Copy Chromium browser config to a control location, alias: ctc

set -euo pipefail

# Ensure the destination directory exists
dest="$HOME/BrowserProfiles"
if [ ! -d "$dest" ]; then
  echo "Destination directory $dest does not exist. Creating it."
  mkdir -p "$dest"
fi

# Define paths
ccache="$HOME/.cache/chromium"
cconf="$HOME/.config/chromium"
ccontrol="$HOME/BrowserProfiles/chromium"

# Function to copy profile
copy_profile() {
  local source="$1"
  local target="$2"
  echo "Copying $source profile..."
  cp -r "$source" "$target"
}

# Check and copy Chromium profile
if [ -d "$cconf" ]; then
  echo "Removing existing Chromium cache and control directories..."
  rm -rf "$ccache" "$ccontrol"

  copy_profile "$cconf" "$dest"
  echo "Chromium config copied to control."
else
  echo "Chromium source directory not present!"
fi
