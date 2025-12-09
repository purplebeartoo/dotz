#!/usr/bin/env bash
# Ollama stop, alias: osp

set -euo pipefail

container_name="ollama"

# Check if the ollama container is running
if podman inspect --format='{{.State.Running}}' "$container_name" 2>/dev/null | grep -q 'true'; then
  # Stop the container
  if podman stop "$container_name" > /dev/null 2>&1; then
    echo "Ollama stopped successfully."
  else
    echo "Failed to stop Ollama." >&2
    exit 1
  fi
else
  echo "Ollama is not running."
fi
