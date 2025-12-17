#!/usr/bin/env bash
# Remove any unneeded packages, alias: rup

set -euo pipefail

echo "Removing orphaned packages..."
if orphans=$(pacman -Qtdq 2>/dev/null) && [[ -n "$orphans" ]]; then
  echo "$orphans" | sudo xargs -r pacman -Rns --noconfirm -- 2>/dev/null
else
  echo "No orphaned packages found."
fi

echo "Removing explicitly installed packages not required by any package..."
if unused=$(pacman -Qqd 2>/dev/null) && [[ -n "$unused" ]]; then
  echo "$unused" | sudo xargs -r pacman -Rsu --noconfirm -- 2>/dev/null
else
  echo "No unused explicitly installed packages found."
fi

echo "Cleanup complete: removed any unneeded packages."
