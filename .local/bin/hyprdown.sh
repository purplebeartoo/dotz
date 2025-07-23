#!/usr/bin/env bash
# Hyprdown

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

clear_clipboard() {
  if command -v wl-copy > /dev/null; then
    wl-copy -c < /dev/null
  else
    echo "wl-copy not found; clipboard not cleared." >&2
  fi
}

# Validate Ollama history path
ollama_history="$HOME/.local/share/containers/storage/volumes/ollama/_data/history"
if [ -f "$ollama_history" ]; then
  safe_rm_file "$ollama_history"
else
  echo "Ollama history file not found: $ollama_history" >&2
fi

clear_clipboard
poweroff
