#!/usr/bin/env bash
# Cleanup and poweroff, launches via Super+m 

set -euo pipefail

# Function to safely remove a file
safe_rm_file() {
  local file="$1"
  if [ -f "$file" ]; then
    if rm "$file"; then
      echo "Removed: $file"
    else
      echo "Failed to remove: $file" >&2
      return 1
    fi
  else
    echo "File not found: $file" >&2
    return 1
  fi
}

# Remove Ollama history file if present
ollama_history="$HOME/.local/share/containers/storage/volumes/ollama/_data/history"

if [ -f "$ollama_history" ]; then
  if ! safe_rm_file "$ollama_history"; then
    echo "Failed to remove the Ollama history file. Exiting." >&2
    exit 1
  fi
else
  echo "Ollama history file not found: $ollama_history"
fi

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
