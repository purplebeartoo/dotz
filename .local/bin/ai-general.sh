#!/usr/bin/env bash
# Run "general" AI, launches AI terminal client via Ctrl+5

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

# Launch Qwen3-Thinking via Kitty 
kitty -e podman exec -it ollama ollama run hf.co/unsloth/Qwen3-30B-A3B-Thinking-2507-GGUF:Q3_K_XL --verbose
