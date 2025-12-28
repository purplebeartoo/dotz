#!/usr/bin/env bash
# Attended backup, alias: backup

set -euo pipefail

# Function to check NumLock state in a Wayland‑only session
check_numlock() {
  local numlock_state=false
  if [[ -d "/sys/class/leds" ]]; then
    found_led=0
    shopt -s nullglob
    for led_path in /sys/class/leds/*:numlock; do
      found_led=1
      if [[ -f "$led_path/brightness" ]] && [[ "$(cat "$led_path/brightness" 2>/dev/null)" == "1" ]]; then
        numlock_state=true
        break
      fi
    done
    shopt -u nullglob
    # If there were no :numlock LED devices, we cannot reliably check state.
    if (( ! found_led )); then
      numlock_state=unknown
    fi
  else
    numlock_state=unknown
  fi
  echo "$numlock_state"
}

# Check NumLock status
numlock_status=$(check_numlock)

# Handle NumLock state
if [[ "$numlock_status" == "false" ]] && [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
  echo "Error: NumLock is required and must be enabled in this Wayland session." >&2
  exit 1
elif [[ "$numlock_status" == "unknown" ]]; then
  echo "Warning: Unable to detect NumLock state. Proceeding anyway." >&2
fi

backup_file="backup-$(date +"%Y-%m-%d").tar.zst"

directories=(
  ".config"
  ".local/bin"
  ".local/share/bubblejail"
  ".local/share/flatpak/overrides"
  ".local/share/zoxide"
  ".mozilla"
  ".ssh"
  "BrowserProfiles"
  "Documents"
  "Packages"
  "Pictures"
  "Playlists"
  "Videos"
)

# Change to home directory and check for errors
cd "$HOME" || { echo "Error: Failed to change directory to $HOME" >&2; exit 1; }

# Check if all source directories exist. Fail if any are missing.
for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Error: Directory $dir does not exist. Exiting." >&2
    exit 1
  fi
done

# Create backup using tar with compression
echo "Creating backup..."
if ! tar -I 'zstdmt --fast=10' -vcf "$backup_file" "${directories[@]}"; then
  echo "Error: Failed to create tar archive." >&2
  exit 1
fi

# Encrypt the backup file
echo "Encrypting backup..."
if ! age -e -p -o "${backup_file}.age" "$backup_file"; then
  echo "Error: Failed to encrypt the backup." >&2
  rm "$backup_file"
  exit 1
fi

# Remove unencrypted backup after encryption
echo "Removing unencrypted backup..."
if ! rm "$backup_file"; then
  echo "Error: Failed to remove unencrypted backup file." >&2
  exit 1
fi

echo "Backup completed successfully. Encrypted backup is: ${backup_file}.age"
