#!/usr/bin/env bash
# Ollama start, alias: ost

set -euo pipefail

# Check if the ollama container exists (running or stopped)
if ! podman ps -a --format '{{.Names}}' | grep -q '^ollama$'; then
  echo "Container 'ollama' does not exist." >&2
  exit 1
fi

# Check if the ollama container is running
if ! podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  # Start the container
  if podman start ollama > /tmp/ollama_start.log 2>&1; then
    echo "Ollama started successfully."
  else
    echo "Failed to start Ollama." >&2
    cat /tmp/ollama_start.log >&2
    exit 1
  fi
else
  echo "Ollama is already running."
fi
