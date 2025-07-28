#!/usr/bin/env bash
# New install

# Create a directory for the downloaded files
mkdir -p ~/tmpscripts

# Function to download and check the success of each file
download_file() {
  local url=$1
  local destination=$2

  # Check if the download was successful directly
  if ! wget --quiet -O "$destination" "$url"; then
    echo "Failed to download $url"
    exit 1
  fi

  # Make the downloaded files executable
  chmod +x "$destination"
}

# Download and install the scripts
download_file https://raw.githubusercontent.com/purplebeartoo/dotz/master/.local/bin/admin-write-config.sh ~/tmpscripts/awc
download_file https://raw.githubusercontent.com/purplebeartoo/dotz/master/.local/bin/hyprland-from-source.sh ~/tmpscripts/hfs
download_file https://raw.githubusercontent.com/purplebeartoo/dotz/master/.local/bin/package-install.sh ~/tmpscripts/pkginstall
download_file https://raw.githubusercontent.com/purplebeartoo/dotz/master/.local/bin/user-write-config.sh ~/tmpscripts/uwc

echo "Download and installation completed successfully."
