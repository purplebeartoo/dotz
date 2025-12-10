#!/usr/bin/env bash
# Rebuild Hyprland AUR packages, alias: rha

set -euo pipefail

# Check if paru is available
if ! command -v paru &> /dev/null; then
    echo "Error: paru not found. Please install paru first."
    exit 1
fi

# Clean up cache, unused sync repositories, all AUR packages, and saved diffs
echo "Cleaning up before rebuilding..."
if ! paru --noconfirm -Scc; then
  echo "Error: Failed to clean up."
  exit 1
fi

rebuild_package() {
  local pkg=$1
  echo "Rebuilding $pkg..."

  # Validate package exists in repositories
  if ! paru -Sl | grep -q "^$pkg "; then
    echo "Warning: $pkg not found in repositories, skipping..."
    return 1
  fi

  if paru --noconfirm -S --rebuild "$pkg"; then
    echo "Successfully rebuilt $pkg."
  else
    echo "Failed to rebuild $pkg. Please check the error messages above."
    exit 1
  fi
}

# AUR Git packages
packages=(
  hyprlang-git
  hyprcursor-git
  hyprwayland-scanner-git
  hyprutils-git
  hyprgraphics-git
  aquamarine-git
  hyprland-guiutils-git
  hyprwire-git
  hypridle-git
  hyprlock-git
  hyprpaper-git
  xdg-desktop-portal-hyprland-git
)

# Rebuild each package
for pkg in "${packages[@]}"; do
  rebuild_package "$pkg"
done

echo "Package rebuilds completed successfully."
