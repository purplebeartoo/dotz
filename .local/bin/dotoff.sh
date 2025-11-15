#!/usr/bin/env bash
# Disable DNS over TLS, alias: dotoff

set -euo pipefail

systemd_resolved_conf="/etc/NetworkManager/conf.d/10-dns-systemd-resolved.conf"
resolved_conf="/etc/systemd/resolved.conf"

# Remove systemd-resolved configuration if it exists
if [ -f "$systemd_resolved_conf" ]; then
  if ! sudo rm -f "$systemd_resolved_conf"; then
    echo "Failed to remove $systemd_resolved_conf"
    exit 1
  fi
fi

# Remove resolved.conf if it exists
if [ -f "$resolved_conf" ]; then
  if ! sudo rm -f "$resolved_conf"; then
    echo "Failed to remove $resolved_conf"
    exit 1
  fi
fi

# Disable and stop systemd-resolved
if ! sudo systemctl disable systemd-resolved --now; then
  echo "Failed to disable systemd-resolved"
  exit 1
fi

# Restart NetworkManager
if ! sudo systemctl restart NetworkManager; then
  echo "Failed to restart NetworkManager"
  exit 1
fi

echo "DNS over TLS is disabled."
