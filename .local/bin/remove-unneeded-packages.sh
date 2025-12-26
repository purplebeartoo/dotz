#!/usr/bin/env bash
# Remove unneeded packages and clean package cache, alias: rup

set -euo pipefail

# Remove orphaned packages
echo "Removing orphaned packages..."
orphaned=$(pacman -Qdtq || true)  # Allow command to fail if no orphans found
if [ -n "$orphaned" ]; then
  sudo pacman -Rns --noconfirm "$orphaned"
  echo "Orphaned packages removed successfully."
else
  echo "No orphaned packages found."
fi

# Remove installed packages ending with .debug
echo "Removing packages ending with .debug..."
debug_packages=$(pacman -Qq | grep '\.debug$' || true)  # Allow grep to fail if no .debug packages found
if [ -n "$debug_packages" ]; then
  sudo pacman -Rns --noconfirm "$debug_packages"
  echo "Packages ending with .debug removed successfully."
else
  echo "No .debug packages found."
fi

# Clean up package cache
echo "Cleaning up package cache..."
sudo pacman -Scc --noconfirm
echo "Package cache cleaned successfully."

echo "Package cleanup completed successfully."
