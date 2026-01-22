#!/usr/bin/env bash
# Run the coding AI, launches AI terminal client via Ctrl+Numpad 4

set -euo pipefail

container="${1:-ollama}"
model="${2:-hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:UD-Q3_K_XL}"

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

# Launch the coding AI
podman exec -it "$container" ollama run "$model" --verbose
