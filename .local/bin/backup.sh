#!/usr/bin/env bash
# Backup, alias: backup

# Strict bash execution mode
set -euo pipefail

backup_file="backup-$(date +"%Y-%m-%d").tar.zst"
directories=(
  ".config"
  ".local/bin"
  ".local/share/bubblejail"
  ".local/share/flatpak/overrides"
  ".ssh"
  "BrowserProfiles"
  "Documents"
  "Packages"
  "Pictures"
  "Playlists"
  "Videos"
)

# Go home
cd "$HOME" || { echo "Error: Failed to change directory to $HOME"; exit 1; }

# Check source directories
for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Warning: Directory $dir does not exist."
    exit 1
  fi
done

# Create backup
if ! tar -I 'zstdmt --fast=10' -vcf "$backup_file" "${directories[@]}"; then
  echo "Error: Failed to create tar archive."
  exit 1
fi

# Encrypt backup
if ! age -e -p -o "${backup_file}.age" "$backup_file"; then
  echo "Error: Failed to encrypt the backup."
  rm "$backup_file"
  exit 1
fi

# Remove unencrypted backup
if ! rm "$backup_file"; then
  echo "Error: Failed to remove unencrypted backup file."
  exit 1
fi

echo "Backup complete."
