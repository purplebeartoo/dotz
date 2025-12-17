#!/usr/bin/env bash
# Update Podman Ollama, alias: upo

set -euo pipefail

# Function to check if the ollama container is running and stop it
stop_ollama_if_running() {
  if podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
    echo "Stopping the ollama container..."
    if ! podman stop ollama; then
      echo "Warning: Failed to stop the ollama container. Proceeding with removal."
    fi
  else
    echo "Ollama container is not running."
  fi
}

# Trap for unexpected errors to provide clean exit
trap 'echo "Error occurred. Exiting." >&2; exit 1' ERR

# Stop the ollama container if it's running
stop_ollama_if_running

# Remove the ollama container
echo "Removing the ollama container..."
if ! podman rm ollama; then
  echo "Warning: Could not remove the ollama container. It may not exist or was already removed."
fi

# Pull the latest ollama image
echo "Pulling the latest ollama image..."
if ! podman pull ollama/ollama:rocm; then
  echo "Error: Failed to pull the ollama image. Exiting."
  exit 1
fi

# Run the ollama container with specified options
echo "Running the ollama container..."
if ! podman run --pull newer --detach --replace \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --name ollama \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  ollama/ollama:rocm; then
  echo "Error: Failed to run the ollama container. Exiting."
  exit 1
fi

# Verify that the container started successfully
echo "Verifying container startup..."
if podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  echo "Ollama container has been updated and started successfully."
else
  echo "Warning: Ollama container may not be running properly"
fi
