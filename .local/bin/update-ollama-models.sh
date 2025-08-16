#!/usr/bin/env bash
# Update all Ollama models, alias: uom

# Strict bash execution mode
set -euo pipefail

# Check if the ollama container exists
if ! podman ps -a --format '{{.Names}}' | grep -q '^ollama$'; then
  echo "Container 'ollama' does not exist. Please create it first."
  exit 1
fi

# Check if the ollama container is running
if ! podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  # Start the container
  podman start ollama
fi

# Get list of installed models
models=$(podman exec ollama ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')

if [ -z "$models" ]; then
  echo "No models found to update"
  exit 0
fi

echo "Starting bulk update for Ollama models..."
echo "Found $(echo "$models" | wc -l) model(s) to update"

for model in $models; do
  echo "Updating $model..."

  if podman exec ollama ollama pull "$model" 2>/dev/null; then
    echo "Successfully updated $model"
  else
    echo "Failed to update $model"
  fi

  sleep 1
done

echo "Bulk update completed!"
