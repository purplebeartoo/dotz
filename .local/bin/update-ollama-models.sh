#!/usr/bin/env bash
# Update all Ollama models, alias: uom

set -euo pipefail

# Verify container exists
if ! podman container inspect ollama >/dev/null 2>&1; then
  echo "Error: Container 'ollama' does not exist. Create it first." >&2
  exit 1
fi

# Start container if needed
if [ "$(podman inspect -f '{{.State.Running}}' ollama)" != "true" ]; then
  podman start ollama
fi

# Wait for ollama service to initialize (max 10s)
for _ in {1..10}; do
  if podman exec ollama ollama list >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

# Confirm service readiness
if ! podman exec ollama ollama list >/dev/null 2>&1; then
  echo "Error: Ollama service not ready after 10s. Check container logs." >&2
  exit 1
fi

# Safely extract model names
models=$(podman exec ollama ollama list | awk 'NR>1 {print $1}')
if [ -z "$models" ]; then
  echo "No models found to update." >&2
  exit 0
fi

# Update models safely
echo "Updating models:"
echo "$models" | while read -r model; do
  echo "  - $model"
  podman exec ollama ollama pull "$model"
done
echo "All models updated successfully."
