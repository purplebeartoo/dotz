#!/usr/bin/env bash
# Sync backup, alias: sbk

set -euo pipefail
IFS=$'\n\t'

log() {
  printf '[%(%F %T)T] %s\n' -1 "$*"
}

die() {
  log "ERROR: $*"
  exit 1
}

# Configuration
backup_date="$(date +%F)"
backup_source="${HOME}/backup-${backup_date}.tar.zst.age"

backup_destinations=(
  "/run/media/ck/sam3"
  "/run/media/ck/samc"
  "/home/ck/Downloads"
)

dry_run="${dry_run:-0}"

ensure_writable_dir() {
  local dir="$1"

  [[ -d "$dir" ]] || die "Destination directory does not exist: $dir"
  [[ -w "$dir" ]] || die "Destination directory is not writable: $dir"
}

verify_prerequisites() {
  [[ -f "$backup_source" ]] || die "Source file not found: $backup_source"

  for dir in "${backup_destinations[@]}"; do
    ensure_writable_dir "$dir"
  done
}

copy_backup() {
  local failures=0

  for dst in "${backup_destinations[@]}"; do
    log "Copying → $dst"

    if [[ "$dry_run" -eq 1 ]]; then
      log "DRY-RUN: install -p \"$backup_source\" \"$dst/\""
      continue
    fi

    if ! install -p "$backup_source" "$dst/"; then
      log "Copy failed for destination: $dst"
      failures=$((failures + 1))
    fi
  done

  return "$failures"
}

cleanup_source() {
  log "Removing source file: $backup_source"
  rm -f -- "$backup_source"
  log "Source file deleted."
}

main() {
  log "Starting backup sync"

  verify_prerequisites

  if copy_backup; then
    [[ "$dry_run" -eq 1 ]] || cleanup_source
    log "Backup sync completed successfully"
  else
    die "One or more copies failed — source file preserved"
  fi
}

main "$@"
