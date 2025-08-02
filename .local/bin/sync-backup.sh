#!/usr/bin/env bash
# Sync backup, alias: sbk

# Strict bash execution mode
set -euo pipefail

backup_source="$HOME/backup-$(date +"%Y-%m-%d").tar.zst.age"
backup_destinations=(
  "/run/media/ck/sam3"
  "/run/media/ck/samc"
  "/home/ck/Downloads"
)

# Sync function
sync_backup() {
  source_file="$1"
  shift
  destinations=("$@")

  # Check source file
  if [[ ! -f "$source_file" ]]; then
    echo "Source file $source_file does not exist."
    exit 1
  fi

  # Check destinations
  for dest in "${destinations[@]}"; do
    if [[ ! -d "$dest" ]]; then
      echo "Destination directory $dest does not exist."
      exit 1
    fi

    # Copy file
    echo "Copying $source_file to $dest"
    cp -a "$source_file" "$dest"
    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
      echo "Failed to copy $source_file to $dest"
      exit 1
    fi
  done

  # Remove source file
  rm "$source_file"
  exit_code=$?
  if [[ $exit_code -eq 0 ]]; then
    echo "Source file $source_file has been deleted."
  else
    echo "Failed to delete source file $source_file."
    exit 1
  fi
}
# Execute sync
sync_backup "$backup_source" "${backup_destinations[@]}"
echo "Backup sync complete."
