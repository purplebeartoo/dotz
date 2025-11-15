#!/usr/bin/env bash
# Build Hyprland from source, alias: hfs

set -euo pipefail

# Go home
cd "$HOME" || { echo "Error: Failed to change directory to $HOME"; exit 1; }

# Check if Hyprland directory exists and delete it
if [ -d "Hyprland" ]; then
  echo "Hyprland directory found. Deleting it..."
  rm -rf "Hyprland"
fi

echo "Cloning Hyprland from GitHub..."
git clone --depth 1 --recursive https://github.com/hyprwm/Hyprland || {
  echo "Error: Failed to clone Hyprland repository."
  exit 1
}

cd Hyprland || {
  echo "Error: Failed to enter Hyprland directory."
  exit 1
}

echo "Configuring Hyprland build..."
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DNO_XWAYLAND:STRING=true -DNO_UWSM:STRING=true -DNO_HYPRPM:STRING=true -B build || {
  echo "Error: CMake configuration failed."
  exit 1
}

echo "Building Hyprland..."
cmake --build ./build --config Release --target all -j"$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)" || {
  echo "Error: Hyprland build failed."
  exit 1
}

echo "Installing Hyprland..."
sudo cmake --install ./build || {
  echo "Error: Hyprland installation failed."
  exit 1
}

echo "Remove the cloned repository..."
cd "$HOME" || { echo "Error: Failed to change directory to $HOME"; exit 1; }
rm -rf "Hyprland"

echo "Hyprland was successfully built and installed."
