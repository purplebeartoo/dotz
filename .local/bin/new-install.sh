#!/usr/bin/env bash
# System setup bootstrapper

set -euo pipefail

# Verify required commands are available
required_cmds=(chmod git wget)
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: required command '$cmd' not found. please install it first."
    exit 1
  fi
done

# Clone yay-bin from AUR and build it
cd /tmp || exit 1

# Clone yay-bin repository
echo "Cloning yay-bin from AUR..."
if ! git clone https://aur.archlinux.org/yay-bin.git; then
    echo "Error: Failed to clone yay-bin repository."
    exit 1
fi

# Change to the cloned directory
cd yay-bin || exit 1

# Build and install yay-bin
echo "Building and installing yay-bin..."
if ! makepkg -si --noconfirm; then
    echo "Error: Failed to build and install yay-bin."
    cd /tmp
    rm -rf yay-bin
    exit 1
fi

# Clean up Yay build
cd /tmp
rm -rf yay-bin

# Configure temporary scripts directory
tmpscripts_dir="${1:-$HOME/tmpscripts}" # allow custom target, default to ~/tmpscripts

# Create directory structure for temporary scripts
echo "Creating temporary directory at: $tmpscripts_dir"
if ! mkdir -p "$tmpscripts_dir"; then
  echo "Error: Failed to create directory $tmpscripts_dir"
  exit 1
fi

# Define mapping of source filenames to destination name
declare -A files_to_download=(
  [hyprland-from-source.sh]="hfs"
  [manual-build-install.sh]="mbinst"
  [package-install.sh]="packinst"
  [write-system-configs.sh]="wsc"
)

# Initialize download function
base_url="https://raw.githubusercontent.com/purplebeartoo/dotz/master/.local/bin"

download_file() {
  local url="$1"
  local dest="$2"
  echo -n "Downloading $url ... "
  if wget --quiet -O "$dest" "$url"; then
    chmod +x "$dest"
    echo "Done."
  else
    echo "Script downloads failed!"
    exit 1
  fi
}

echo "Starting downloads..."
for src in "${!files_to_download[@]}"; do
  url="$base_url/$src"
  dest="$tmpscripts_dir/${files_to_download[$src]}"
  download_file "$url" "$dest"
done

# Download linuxnotes to root directory
echo -n "Downloading https://raw.githubusercontent.com/purplebeartoo/dotz/master/Documents/linuxnotes..."
if wget --quiet -O "$HOME/linuxnotes" "https://raw.githubusercontent.com/purplebeartoo/dotz/master/Documents/linuxnotes"; then
  echo "Done."
else
  echo "Linuxnotes download failed!"
  exit 1
fi

# Download hyprland.conf to .config/hypr
mkdir -p "$HOME/.config/hypr"
echo -n "Downloading https://raw.githubusercontent.com/purplebeartoo/dotz/master/.config/hypr/hyprland.conf... "
if wget --quiet -O "$HOME/.config/hypr/hyprland.conf" "https://raw.githubusercontent.com/purplebeartoo/dotz/master/.config/hypr/hyprland.conf"; then
  echo "Done."
else
  echo "Hyprland.conf download failed!"
  exit 1
fi

echo "All downloads complete!"
