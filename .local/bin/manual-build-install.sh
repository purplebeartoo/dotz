#!/usr/bin/env bash
# Install manual build packages

set -euo pipefail

# Check if yay is available
if ! command -v yay &> /dev/null; then
    echo "Error: yay not found. Please install yay first."
    exit 1
fi

# Pacman packages
echo "Installing pacman manual build packages..."
sudo pacman -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm libinput libliftoff libdisplay-info cpio tomlplusplus xcb-util-errors glaze re2 muparser || {
  echo "Error: Failed to install Hyprland AUR packages. Check yay logs."
  exit 1
}

# AUR packages
echo "Installing AUR manual build packages..."
yay -S hyprlang-git hyprcursor-git hyprwayland-scanner-git hyprutils-git hyprgraphics-git aquamarine-git hyprland-guiutils-git hyprwire-git hypridle-git hyprlock-git hyprpaper-git xdg-desktop-portal-hyprland-git || {
  echo "Error: Failed to install Hyprland AUR packages. Check yay logs."
  exit 1
}

echo "Hyprland manual build packages installed."
