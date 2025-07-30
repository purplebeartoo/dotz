#!/bin/bash
# Rebuild Hyprland AUR, alias: rha

# Clean up cache, unused sync repositories, all AUR packages, and saved diffs
echo "Cleaning up before rebuilding..."
if ! yes | paru -Sccdd; then
  echo "Error: Failed to clean up."
  exit 1
fi

rebuild_package() {
  local pkg=$1
  echo "Rebuilding $pkg..."
  if paru --noconfirm -S --rebuild "$pkg"; then
    echo "Successfully rebuilt $pkg."
  else
    echo "Failed to rebuild $pkg. Please check the error messages above."
    exit 1
  fi
}

# List of packages to rebuild
packages=(
  hyprlang-git
  hyprcursor-git
  hyprwayland-scanner-git
  hyprutils-git
  hyprgraphics-git
  aquamarine-git
  hyprland-qtutils-git
  hypridle-git
  hyprlock-git
  hyprpaper-git
  xdg-desktop-portal-hyprland-git
)

# Rebuild each package
for pkg in "${packages[@]}"; do
  rebuild_package "$pkg"
done

echo "All packages have been rebuilt successfully."
