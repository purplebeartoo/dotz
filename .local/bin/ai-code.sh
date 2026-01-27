#!/usr/bin/env bash
# Run the coding AI inside a Podman container, launches via Ctrl+Numpad 4

set -Eeuo pipefail

# Configuration
DEFAULT_CONTAINER="ollama"
DEFAULT_MODEL="hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:UD-Q3_K_XL"

container="${1:-$DEFAULT_CONTAINER}"
model="${2:-$DEFAULT_MODEL}"

# Helpers
err() {
  echo "Error: $*" >&2
}

die() {
  err "$@"
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

# Preconditions
require_cmd podman

# Container checks
if ! podman container exists "$container"; then
  die "Container '$container' does not exist. Create it first."
fi

if ! podman ps --format '{{.Names}}' | grep -qxF "$container"; then
  echo "Starting container '$container'..."
  podman start "$container" >/dev/null \
    || die "Failed to start container '$container'"
fi

# Ensure ollama exists inside the container
if ! podman exec "$container" sh -c '[ -x "$(command -v ollama)" ]'; then
  die "ollama not found inside container '$container'"
fi

# Model checks
if ! podman exec "$container" ollama list \
  | awk '{print $1}' \
  | grep -qxF "$model"; then

  echo "Pulling model '$model'..."
  podman exec "$container" ollama pull "$model" \
    || die "Failed to pull model '$model'"
fi

# Launch
echo "Launching the coding AI ($model) in container '$container'..."
exec podman exec -it "$container" ollama run "$model" --verbose
