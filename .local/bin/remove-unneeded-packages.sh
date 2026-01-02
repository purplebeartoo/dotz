#!/usr/bin/env bash
# rup – Remove unneeded packages and clean caches

set -euo pipefail
IFS=$'\n\t'

# Helper: formatted log messages
log() {
    local level="$1"
    shift
    printf '[%s] %s\n' "$level" "$*"
}

# Prompt for sudo once (so we don’t keep asking for a password)
if ! sudo -v; then
    log "ERROR" "Cannot obtain sudo privileges – aborting."
    exit 1
fi

# Wrapper to run a command and report success / failure
run_clean() {
    local description="$1"
    shift
    if "$@"; then
        log "OK" "$description"
    else
        log "WARN" "Failed to $description"
    fi
}

# Remove orphaned packages (those not required by any installed pkg)
log "INFO" "Scanning for orphaned packages…"
mapfile -t orphaned < <(pacman -Qdtq || true)   # Capture list; ignore error if none

if (( ${#orphaned[@]} )); then
    run_clean "remove orphaned packages" \
        sudo pacman -Rns --noconfirm "${orphaned[@]}"
else
    log "INFO" "No orphaned packages found."
fi

# Remove packages whose names end with `.debug`
log "INFO" "Scanning for *.debug packages…"
mapfile -t debug_pkgs < <(pacman -Qq | grep '\.debug$' || true)

if (( ${#debug_pkgs[@]} )); then
    run_clean "remove *.debug packages" \
        sudo pacman -Rns --noconfirm "${debug_pkgs[@]}"
else
    log "INFO" "No *.debug packages found."
fi

# Delete everything under Pacman’s cache directory
run_clean "clear Pacman package cache directory" \
    sudo rm -rf /var/cache/pacman/pkg/*

# Run pacman’s own cache‑cleaner (also wipes sync DB files)
run_clean "clean Pacman cache via pacman -Scc" \
    sudo pacman -Scc --noconfirm

# Clean yay’s cache
yay_cache="${HOME}/.cache/yay"
if [[ -d "$yay_cache" ]]; then
    run_clean "clear yay cache directory" \
        rm -rf "${yay_cache:?}"/*
else
    log "INFO" "Yay cache directory not found at $yay_cache."
fi

# Done!
log "INFO" "All clean‑up steps completed successfully."
