#!/usr/bin/env bash
# Install AUR packages

set -euo pipefail

# Check if paru is available
if ! command -v paru &> /dev/null; then
    echo "Error: paru not found. Please install paru first."
    exit 1
fi

# AUR install
echo "Installing AUR packages..."
paru -S bubblejail rose-pine-cursor rose-pine-hyprcursor tokyonight-gtk-theme-git waybar-module-pacman-updates-git wezterm-git yaru-colors-icon-theme || {
  echo "Error: Failed to install AUR packages. Check Paru logs."
  exit 1
}

# Hyprland manual build packages
echo "Installing Hyprland manual build packages..."
paru -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 muparser hyprland-guiutils-git hyprwire-git hypridle-git hyprlock-git hyprpaper-git xdg-desktop-portal-hyprland-git || {
  echo "Error: Failed to install Hyprland AUR packages. Check Paru logs."
  exit 1
}

echo "AUR package installation complete."
