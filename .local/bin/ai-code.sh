#!/usr/bin/env bash
# Run the coding AI, alias: aic

set -euo pipefail

container="${1:-ollama}"
model="${2:-hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:UD-Q3_K_XL}"

# Error handling function that outputs to stderr
err() { echo "error: $*" >&2; }

# Check if the specified container exists
if ! podman container exists "$container"; then
  err "container '$container' does not exist. Please create it first."
  exit 1
fi

# Check if the container is running, if not start it
if ! podman ps --format '{{.Names}}' | grep -qx "$container"; then
  podman start "$container" || { err "Failed to start $container"; exit 1; }
fi

# Check if the specified model is available in the container, if not pull it
if ! podman exec "$container" ollama list | grep -Fq "$model"; then
  podman exec "$container" ollama pull "$model" || { err "Failed to pull $model"; exit 1; }
fi

# Launch the coding AI terminal client
podman exec -it "$container" ollama run "$model" --verbose
