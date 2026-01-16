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

fcache="$HOME/.cache/mozilla"
fconf="$HOME/.config/mozilla"
fcontrol="$HOME/BrowserProfiles/mozilla"

# Function to copy a profile using rsync
copy_profile() {
  local source="$1"
  local target="$2"
  echo "Syncing $source profile to $target …"
  rsync -avzq --delete "$source" "$target"
}

# Check and copy Chromium profile
if [ -d "$cconf" ]; then
  echo "Removing existing Chromium cache and control directories..."
  rm -rf "$ccache" "$ccontrol"

  copy_profile "$cconf" "$dest/chromium"
  echo "Chromium config copied to control."
else
  echo "Chromium source directory not present!"
fi

# Check and copy Firefox profile
if [ -d "$fconf" ]; then
  echo "Removing existing Firefox cache and control directories..."
  rm -rf "$fcache" "$fcontrol"

  copy_profile "$fconf" "$dest/mozilla"
  echo "Firefox config copied to control."
else
  echo "Firefox source directory not present!"
fi
