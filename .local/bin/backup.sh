#!/usr/bin/env bash
# Attended backup, alias: backup

# Strict bash execution mode
set -euo pipefail

# Check NumLock state in a Wayland‑only session
numlock_enabled=false
if [[ -d "/sys/class/leds" ]]; then
  found_led=0
  shopt -s nullglob
  for led_path in /sys/class/leds/*:numlock; do
    found_led=1
    if [[ -f "$led_path/brightness" ]] && [[ "$(cat "$led_path/brightness" 2>/dev/null)" == "1" ]]; then
      numlock_enabled=true
      break
    fi
  done
  shopt -u nullglob
  # If there were no :numlock LED devices, we cannot reliably check state.
  if (( ! found_led )); then
    numlock_enabled=unknown
  fi
else
  numlock_enabled=unknown
fi

if [[ "${numlock_enabled}" == false ]] && [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
  echo "Error: NumLock is required and must be enabled in this Wayland session." >&2
  exit 1
elif [[ "${numlock_enabled}" == unknown ]]; then
  echo "Warning: Unable to detect NumLock state. Proceeding anyway." >&2
fi

backup_file="backup-$(date +"%Y-%m-%d").tar.zst"

directories=(
  ".config"
  ".local/bin"
  ".local/share/bubblejail"
  ".local/share/flatpak/overrides"
  ".local/share/zoxide"
  ".ssh"
  "BrowserProfiles"
  "Documents"
  "Packages"
  "Pictures"
  "Playlists"
  "Videos"
)

# Go home
cd "$HOME" || { echo "Error: Failed to change directory to $HOME" >&2; exit 1; }

# Check source directories
for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Warning: Directory $dir does not exist." >&2
    exit 1
  fi
done

# Create backup
if ! tar -I 'zstdmt --fast=10' -vcf "$backup_file" "${directories[@]}"; then
  echo "Error: Failed to create tar archive." >&2
  exit 1
fi

# Encrypt backup
if ! age -e -p -o "${backup_file}.age" "$backup_file"; then
  echo "Error: Failed to encrypt the backup." >&2
  rm "$backup_file"
  exit 1
fi

# Remove unencrypted backup
if ! rm "$backup_file"; then
  echo "Error: Failed to remove unencrypted backup file." >&2
  exit 1
fi

echo "Backup complete."
