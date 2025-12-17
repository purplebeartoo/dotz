#!/usr/bin/env bash
# Cleanup and poweroff, launches via Super+m 

set -euo pipefail

# Function to clear clipboard
clear_clipboard() {
  if command -v wl-copy > /dev/null; then
    if ! wl-copy -c < /dev/null; then
      echo "Failed to clear clipboard." >&2
      return 1
    fi
  else
    echo "wl-copy not found; clipboard not cleared." >&2
    return 1
  fi
}

if ! clear_clipboard; then
  echo "Failed to clear clipboard. Proceeding with shutdown anyway..." >&2
fi

poweroff
