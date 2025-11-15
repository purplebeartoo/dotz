#!/usr/bin/env bash
# Copy Firefox browser profiles to a control location, alias: ctc

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
fcache="$HOME/.cache/mozilla"
fconf="$HOME/.mozilla"
fcontrol="$HOME/BrowserProfiles/.mozilla"

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
  echo "Chromium profile copied to control."
else
  echo "Chromium source directory not present!"
fi

# Check and copy Firefox profile
if [ -d "$fconf" ]; then
  echo "Removing existing Firefox cache and control directories..."
  rm -rf "$fcache" "$fcontrol"

  copy_profile "$fconf" "$dest"
  echo "Firefox profile copied to control."
else
  echo "Firefox source directory not present!"
fi
