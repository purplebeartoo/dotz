#!/usr/bin/env bash
# Delete Chromium profile, alias: dcp

# Strict bash execution mode
set -euo pipefail

ccache=$HOME/.cache/chromium
cconf=$HOME/.config/chromium
ccont=$HOME/BrowserProfiles/chromium
dest=$HOME/.config

if [ ! -d "$ccont" ]; then
  if [ -t 1 ]; then
    echo "Source directory not present!"
  fi
  exit 1
fi

# Attempt to remove the cache and config directories
if rm -rf "$ccache" "$cconf"; then
  # Check if removal was successful by ensuring they no longer exist
  if [ ! -d "$ccache" ] && [ ! -d "$cconf" ]; then
    echo "Cache and config directories successfully removed."
  else
    echo "Failed to completely remove cache or config directories."
    exit 1
  fi
else
  echo "Error removing cache or config directories."
  exit 1
fi

# Attempt to copy the profile directory
if cp -r "$ccont" "$dest"; then
  # Check if copy was successful by ensuring the destination exists
  if [ -d "$dest/chromium" ]; then
    echo "Chromium profile successfully copied."
  else
    echo "Failed to copy Chromium profile."
    exit 1
  fi
else
  echo "Error copying Chromium profile."
  exit 1
fi

# Notify the user if the script is running in a terminal
if [ -t 1 ]; then
  echo "Active Chromium profile deleted and new one copied successfully."
fi
