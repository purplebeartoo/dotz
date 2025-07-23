#!/usr/bin/env bash
# Delete Chromium profile, alias: dcp

# Define paths
ccache=$HOME/.cache/chromium
cconf=$HOME/.config/chromium
ccont=$HOME/BrowserProfiles/chromium
dest=$HOME/.config

# Check if source directory exists and is not a symlink
if [ -d "$ccont" ] && [ ! -L "$ccont" ]; then
  # Check if destination is a valid and writable directory
  if [ -d "$dest" ] && [ -w "$dest" ]; then
    # Attempt to delete existing profile data
    if ! rm -rf "$ccache" "$cconf"; then
      echo "Error: Failed to delete existing Chromium profile data."
      exit 1
    fi

    # Attempt to copy new profile
    if ! cp -r "$ccont" "$dest"; then
      echo "Error: Failed to copy new Chromium profile."
      exit 1
    fi

    # Success message
    if [ -t 1 ]; then
      echo "Active Chromium profile deleted and replaced."
    fi
  else
    echo "Error: Destination directory '$dest' is not valid or not writable."
    exit 1
  fi
else
  echo "Error: Source directory '$ccont' is missing or is a symlink."
  exit 1
fi
