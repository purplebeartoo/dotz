#!/bin/bash
# Rebuild Hyprland AUR, alias: rha

echo "Rebuilding AUR packages..."
paru -Syu --rebuild --rebuild=all hyprlang-git hyprcursor-git hyprwayland-scanner-git hyprutils-git hyprgraphics-git aquamarine-git hyprland-qtutils-git hypridle-git hyprlock-git hyprpaper-git xdg-desktop-portal-hyprland-git || {
  echo "Error: Failed to rebuild AUR packages."
  exit 1
}

echo "Rebuilding complete."
