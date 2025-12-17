#!/usr/bin/env bash
# Enable DNS over TLS, alias: doton

set -euo pipefail

# Set paths
config_dir="$HOME/.config/nextdns"
age_file="$config_dir/nxtdot.zip.age"
zip_file="$config_dir/nxtdot.zip"
systemd_resolved_conf="/etc/NetworkManager/conf.d/10-dns-systemd-resolved.conf"
resolved_conf="/etc/systemd/resolved.conf"

# Change to the NextDNS configuration directory
cd "$config_dir" || { echo "Error: Failed to change directory to $config_dir"; exit 1; }

# Check if the encrypted configuration file exists and is readable
if [ ! -f "$age_file" ]; then
  echo "Error: File $age_file does not exist or is not readable."
  exit 1
fi

# Decrypt the .age file
age -d -o "$zip_file" "$age_file" || { echo "Error: Failed to decrypt $age_file."; exit 1; }

# Check if the decrypted ZIP file was created
if [ ! -f "$zip_file" ]; then
  echo "Error: Failed to create decrypted ZIP file $zip_file."
  exit 1
fi

# Unzip the decrypted file
unzip "$zip_file" || { echo "Error: Failed to unzip $zip_file."; exit 1; }

# Check if required configuration files exist after unzipping
required_files=("10-dns-systemd-resolved.conf" "resolved.conf")
for file in "${required_files[@]}"; do
  if [ ! -f "$config_dir/$file" ]; then
    echo "Error: Missing required file $config_dir/$file after unzipping."
    exit 1
  fi
done

# Move configuration files to appropriate locations
sudo mv "$config_dir/10-dns-systemd-resolved.conf" "$systemd_resolved_conf" || {
  echo "Error: Failed to move 10-dns-systemd-resolved.conf to $systemd_resolved_conf."
  exit 1
}

sudo mv "$config_dir/resolved.conf" "$resolved_conf" || {
  echo "Error: Failed to move resolved.conf to $resolved_conf."
  exit 1
}

# Remove the decrypted ZIP file
rm "$zip_file" || { echo "Error: Failed to remove temporary file $zip_file."; exit 1; }

# Enable systemd-resolved and restart NetworkManager
sudo systemctl enable systemd-resolved --now || {
  echo "Error: Failed to enable systemd-resolved."
  exit 1
}

sudo systemctl restart NetworkManager || {
  echo "Error: Failed to restart NetworkManager."
  exit 1
}

# Confirm DNS over TLS is enabled
echo "DNS over TLS is enabled."
