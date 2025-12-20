#!/usr/bin/env bash
# System setup bootstrapper

set -euo pipefail

# Verify required commands are available
required_cmds=(chmod git wget)
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "error: required command '$cmd' not found. please install it first."
    exit 1
  fi
done

# Clone yay-bin from AUR and build it
cd /tmp || exit 1

# Clone yay-bin repository
echo "Cloning yay-bin from AUR..."
if ! git clone https://aur.archlinux.org/yay-bin.git; then
    echo "Error: Failed to clone yay-bin repository"
    exit 1
fi

# Change to the cloned directory
cd yay-bin || exit 1

# Build and install yay-bin
echo "Building and installing yay-bin..."
if ! makepkg -si --noconfirm; then
    echo "Error: Failed to build and install yay-bin"
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
echo "creating temporary directory at: $tmpscripts_dir"
if ! mkdir -p "$tmpscripts_dir"; then
  echo "error: failed to create directory $tmpscripts_dir"
  exit 1
fi

# Define mapping of source filenames to destination name
declare -A files_to_download=(
  [manual-build-install.sh]="mbinst"
  [package-install.sh]="packinst"
  [write-system-configs.sh]="wsc"
)

# Initialize download function with error handling
base_url="https://raw.githubusercontent.com/purplebeartoo/dotz/master/.local/bin"

download_file() {
  local url="$1"
  local dest="$2"
  echo -n "downloading $url ... "
  if wget --quiet -O "$dest" "$url"; then
    chmod +x "$dest"
    echo "done."
  else
    echo "script downloads failed!"
    exit 1
  fi
}

echo "starting downloads..."
for src in "${!files_to_download[@]}"; do
  url="$base_url/$src"
  dest="$tmpscripts_dir/${files_to_download[$src]}"
  download_file "$url" "$dest"
done

# Download linuxnotes.txt to root directory
echo -n "downloading https://raw.githubusercontent.com/purplebeartoo/dotz/master/Documents/linuxnotes.txt ... "
if wget --quiet -O "$HOME/linuxnotes" "https://raw.githubusercontent.com/purplebeartoo/dotz/master/Documents/linuxnotes.txt"; then
  echo "done."
else
  echo "linuxnotes download failed!"
  exit 1
fi

echo "all downloads complete!"
echo "scripts available in: $tmpscripts_dir"
echo "linuxnotes available in: $HOME"
