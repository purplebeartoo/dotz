#!/usr/bin/env bash
# Run the general use AI, launches AI terminal client via Ctrl+numpad5

set -euo pipefail

container="${1:-ollama}"
model="${2:-hf.co/unsloth/Qwen3-30B-A3B-Thinking-2507-GGUF:Q3_K_XL}"

# Error handling function that outputs to stderr
err() { echo "error: $*" >&2; }

# Check if the specified container exists
if ! podman container exists "$container"; then
  err "container '$container' does not exist. Please create it first."
  exit 1
fi

# Check if the container is running, if not start it
if ! podman ps --format '{{.Names}}' | grep -qx "$container"; then
  podman start "$container" >/dev/null 2>&1 || { err "Failed to start $container"; exit 1; }
fi

# Check if the specified model is available in the container, if not pull it
if ! podman exec "$container" ollama list | grep -Fq "$model"; then
  podman exec "$container" ollama pull "$model" || { err "Failed to pull $model"; exit 1; }
fi

# Launch the general use AI terminal client
podman exec -it "$container" ollama run "$model" --verbose
