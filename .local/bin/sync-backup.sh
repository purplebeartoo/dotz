#!/usr/bin/env bash
# Sync backup, alias: sbk

set -euo pipefail

# Source file (today’s backup)
backup_source="${HOME}/backup-$(date +%F).tar.zst.age"

# Destination directories
backup_destinations=(
  "/run/media/ck/sam3"
  "/run/media/ck/samc"
  "/home/ck/Downloads"
)

# Ensure a directory exists and is writable
ensure_writable_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    echo "Destination directory does not exist: $dir" >&2
    exit 1
  elif [[ ! -w "$dir" ]]; then
    echo "Destination directory is not writable: $dir" >&2
    exit 1
  fi
}

# Copy the source file to each destination, then delete the source
sync_backup() {
  local src="$1"
  shift
  local dests=("$@")

  # Verify source file exists
  if [[ ! -f "$src" ]]; then
    echo "Source file not found: $src" >&2
    exit 1
  fi

  # Copy to each destination
  for dst in "${dests[@]}"; do
    ensure_writable_dir "$dst"
    echo "Copying $src → $dst"
    cp -p "$src" "$dst"
  done

  # Delete source after successful copies
  echo "Removing source file $src"
  rm -f "$src"
  echo "Source file deleted."
}

# Run the sync
sync_backup "$backup_source" "${backup_destinations[@]}"
echo "Backup sync complete."
