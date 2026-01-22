#!/usr/bin/env bash
# Run the general use AI, launches AI terminal client via Ctrl+Numpad 5

set -euo pipefail

container="${1:-ollama}"
model="${2:-hf.co/unsloth/Qwen3-30B-A3B-Thinking-2507-GGUF:Q3_K_XL}"

# Error handling function that outputs to stderr
err() { echo "Error: $*" >&2; }

# Ensure container exists
if ! podman container exists "$container"; then
  err "Container '$container' does not exist. Please create it first."
  exit 1
fi

# Ensure container is running
if ! podman ps --format '{{.Names}}' | grep -qx "$container"; then
  podman start "$container" >/dev/null 2>&1 || { err "Failed to start $container"; exit 1; }
fi

# Ensure model exists within container
if ! podman exec "$container" ollama list | grep -Fq "$model"; then
  podman exec "$container" ollama pull "$model" || { err "Failed to pull $model"; exit 1; }
fi

# Launch the general use AI
podman exec -it "$container" ollama run "$model" --verbose
