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
  local source_file="$1"
  shift
  local destinations=("$@")

  # Check source file
  if [[ ! -f "$source_file" ]]; then
    echo "Error: Source file $source_file does not exist."
    exit 1
  fi

  # Track successful copies
  local success_count=0
  local total_destinations=${#destinations[@]}

  # Copy to all destinations
  for dest in "${destinations[@]}"; do
    # Check destination directory
    if [[ ! -d "$dest" ]]; then
      echo "Error: Destination directory $dest does not exist."
      continue
    fi

    # Copy file
    echo "Copying $source_file to $dest"
    cp -a "$source_file" "$dest"
    local exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
      echo "Successfully copied $source_file to $dest"
      ((success_count++))
    else
      echo "Failed to copy $source_file to $dest"
      exit 1
    fi
  done

  # Check if all copies succeeded
  if [[ $success_count -eq $total_destinations ]]; then
    # Remove source file only if all copies were successful
    rm "$source_file"
    local rm_exit_code=$?

    if [[ $rm_exit_code -eq 0 ]]; then
      echo "Source file $source_file has been deleted."
      echo "Backup sync complete. All $success_count destinations received the backup."
    else
      echo "Error: Failed to delete source file $source_file."
      exit 1
    fi
  else
    echo "Warning: Only $success_count out of $total_destinations destinations received the backup."
    echo "Source file $source_file was not deleted due to incomplete transfers."
    exit 1
  fi
}

# Execute sync
sync_backup "$backup_source" "${backup_destinations[@]}"
echo "Backup sync complete."
