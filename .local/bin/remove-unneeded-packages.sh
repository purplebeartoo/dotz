#!/usr/bin/env bash
# Remove unneeded packages and clean package cache, alias: rup

set -euo pipefail

# Function to check if a command was successful
check_command_success() {
    if [[ $? -ne 0 ]]; then
        echo "Error occurred during the last operation. Exiting."
        exit 1
    fi
}

# Remove orphaned packages
echo "Removing orphaned packages..."
orphaned=$(pacman -Qdtq || true)  # Allow command to fail if no orphans found
if [[ -n "$orphaned" ]]; then
  sudo pacman -Rns --noconfirm "$orphaned"
  check_command_success
  echo "Orphaned packages removed successfully."
else
  echo "No orphaned packages found."
fi

# Remove debug packages
echo "Removing packages ending with .debug..."
debug_packages=$(pacman -Qq | grep '\.debug$' || true)  # Allow grep to fail if no .debug packages found
if [[ -n "$debug_packages" ]]; then
  sudo pacman -Rns --noconfirm "$debug_packages"
  check_command_success
  echo "Packages ending with .debug removed successfully."
else
  echo "No .debug packages found."
fi

# Clean up package cache by removing all cached packages
echo "Cleaning up package cache..."
if sudo rm -rf /var/cache/pacman/pkg/*; then
    echo "Cache directory cleared."
else
    echo "Failed to clean the cache directory. Proceeding with pacman cleanup anyway."
fi

# Remove all cached packages from pacman
sudo pacman -Scc --noconfirm
check_command_success
echo "Package cache cleaned successfully."

# Clean up Yay cache
echo "Cleaning up Yay cache..."
if [[ -d "$HOME/.cache/yay" ]]; then
  rm -rf "$HOME/.cache/yay"/*
  check_command_success
  echo "Yay cache cleaned successfully."
else
  echo "Yay cache directory not found."
fi
